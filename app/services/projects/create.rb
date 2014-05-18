module Services
  module Projects
    class Create < Services::Base
      def call(name, git)
        project = Project.create!(name: name, git: git)
        Services::Projects::Clone.call(project)
        Services::Projects::UpdateTags.call(project.id)
        project
      end
    end
  end
end
