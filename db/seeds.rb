Project.destroy_all

projects = [
  Project.create!(name: 'Ruby', git: 'https://github.com/ruby/ruby.git'),
  Project.create!(name: 'Rails', git: 'https://github.com/rails/rails.git')
]

projects.each do |project|
  begin
    Projects::Clone.call project
  rescue Projects::Clone::FilesExistsError
  end
  Projects::UpdateTags.call project.id
end
