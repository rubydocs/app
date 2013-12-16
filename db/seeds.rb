Project.destroy_all
Doc.destroy_all

projects = [
  Project.create!(name: 'Ruby on Rails', git: 'https://github.com/rails/rails.git'),
  Project.create!(name: 'Sinatra', git: 'https://github.com/sinatra/sinatra.git')
  # Project.create!(name: 'Ruby', git: 'https://github.com/ruby/ruby.git')
]

projects.each do |project|
  begin
    Services::Projects::Clone.call project
  rescue Services::Projects::Clone::FolderExistsError
  end
  Services::Projects::UpdateTags.call project  
end

docs = [
  Project.find_by_name!('Ruby on Rails').docs.create!(tag: 'v4.0.0'),
  Project.find_by_name!('Sinatra').docs.create!(tag: 'v1.0.0')
  # Project.find_by_name!('Ruby').docs.create!(tag: 'v2_0_0_0')
]

Doc.all.each do |doc|
  begin
    Services::Docs::CreateFiles.call doc
  rescue Services::Docs::CreateFiles::FolderExistsError
  end
end
