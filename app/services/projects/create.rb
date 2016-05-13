module Projects
  class Create < Services::Base
    def call(name, git)
      project = Project.create!(name: name, git: git)
      Projects::Clone.call(project)
      Projects::UpdateTags.call(project.id)
      # Reload project so that tags are visible.
      project.reload
    end
  end
end
