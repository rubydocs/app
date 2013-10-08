module Services
  module Projects
    class Create < Services::Base
      def call(name, git)
        project = Project.create(name: name, git: git)
        if project.persisted?
          Services::Projects::Clone.call(project.id)
          Services::Projects::UpdateTags.call(project.id)
        end
        project
      end
    end
  end
end
