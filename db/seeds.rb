Project.destroy_all

project_data = {
  'Ruby'  => 'https://github.com/ruby/ruby.git',
  'Rails' => 'https://github.com/rails/rails.git'
}

projects = project_data.map do |name, git|
  project = Project.create!(name: name, git: git)
  begin
    Projects::Clone.call project
  rescue Projects::Clone::FilesExistsError
  end
  Projects::UpdateTags.call project.id
end
