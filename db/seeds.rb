Project.destroy_all

projects = [
  Project.create!(name: 'Ruby', git: 'https://github.com/ruby/ruby.git'),
  Project.create!(name: 'Rails', git: 'https://github.com/rails/rails.git')
]

projects.each do |project|
  begin
    Services::Projects::Clone.call project
  rescue Services::Projects::Clone::FolderExistsError
  end
  Services::Projects::UpdateTags.call project
end
