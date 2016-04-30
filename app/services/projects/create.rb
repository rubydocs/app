module Projects
  class Create < Services::Base
    def call(name, git)
      project = Project.create!(name: name, git: git)
      Projects::Clone.call(project)
      Projects::UpdateTags.call(project.id)
      project
    end
  end
end
