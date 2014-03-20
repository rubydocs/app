# 20.12.
#
# Set up server and deploy

# Create Postgres user
ssh kc
sudo su - postgres
psql -d template1
create role rubydocs with createdb login password 'mikePost1903';
select * from pg_user; # Verify that user was created
\q
exit
exit

be sprinkle STAGE=production ROOT_PWD=eheaoyhaeefc -vcs config/sprinkle.rb


# 22.12.
#
# Test doc generation

doc = Doc.friendly.find("rails-4-1-0-beta1")

git = Git.open(doc.project.local_path)
git.checkout doc.tag
rdoc = RDoc::RDoc.new
args = [
  '--format=sdoc',
  '--line-numbers',
  "--title=#{doc.name}",
  "--output=#{doc.local_path}",
  '--exclude=test',
  '--exclude=example',
  '--exclude=bin',
  '.'
]
%w(.md .markdown .mdown .txt .rdoc).unshift(nil).each do |suffix|
  readme = "README#{suffix}"
  puts readme
  puts doc.project.local_path.join(readme)
  if File.exist?(doc.project.local_path.join(readme))
    args.unshift("--main=#{readme}")
    break
  end
end
Dir.chdir doc.project.local_path do
  rdoc.document args
end


# 25.12.
#
# Test notifications

doc_collection=DocCollection.find(10)
emails = EmailNotification.by_doc_collection(doc_collection).map(&:email)
Mailer.doc_collection_generated(doc_collection, emails).deliver! if emails.present?

# Update all tags
Project.find_each do |p|
  Services::Projects::UpdateTags.call p
end

# Reprocess doc collections
DocCollection.where(generated_at:nil).each do |dc|
  Services::DocCollections::Process.perform_async dc.id
end


# 27.12.
#
# Regenerate files for failed docs and doc collections

%w(ruby-0-7-1 rails-0-10-0).each do |d_slug|
  d=Doc.friendly.find(d_slug)
  FileUtils.rm_rf d.local_path
  Services::Docs::CreateFiles.call d
  d.doc_collections.where(generated_at:nil).each do |dc|
    FileUtils.rm_rf dc.local_path
    Services::DocCollections::Process.perform_async dc.id
  end
end

[4,8,20,21,28,30,31,33,37,40,42,47,57,62,63,64].each do |id|
  dc=DocCollection.find(id)
  next unless dc.generating?
  FileUtils.rm_rf dc.local_path if File.exists?(dc.local_path)
  Services::DocCollections::Process.perform_async id
end


# 4.1.
#
# Generate ungenerated doc collections

dcs=DocCollection.where(generated_at:nil)
dcs.each do |dc|
  dc.docs.each do |d|
    FileUtils.rm_rf d.local_path if File.exists?(d.local_path)
  end
  FileUtils.rm_rf dc.local_path if File.exists?(dc.local_path)
end
dcs.each do |dc|
  Services::DocCollections::Process.perform_async dc.id
end


# 5.1.
#
# Regenerate all doc collections

dcs=DocCollection.all
dcs.each do |dc|
  dc.docs.each do |d|
    FileUtils.rm_rf d.local_path if File.exists?(d.local_path)
  end
  Services::DocCollections::DeleteFiles.call dc
end
dcs.each_with_index do |dc, i|
  dc.generated_at = nil
  dc.uploaded_at = nil
  dc.save!
  Services::DocCollections::Process.perform_in (i * 2 + 1).hours, dc.id
end


# 17.1.
#
# Regenerate all doc collections AGAIN!

DocCollection.pluck(:id).each_with_index do |id, i|
  RecreateWorker.perform_in (i * 2).hours, id
end
