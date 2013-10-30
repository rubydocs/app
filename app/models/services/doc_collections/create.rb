module Services
  module DocCollections
    class Create < Services::Base
      def call(projects_and_tags)
        project = Services::Projects::Find.call(project_id).first
        doc = project.docs.create(tag: tag)
        if doc.persisted?
          Services::Docs::CreateFiles.call doc.id
        end
        doc
      end
    end
  end
end
