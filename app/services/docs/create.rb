module Services
  module Docs
    class Create < Services::Base
      Error = Class.new(StandardError)

      def call(project_id, tag)
        project = Project.find(project_id)
        doc = project.docs.create(tag: tag)
        if doc.persisted?
          Services::Docs::CreateFiles.call doc.id
        end
        doc
      end
    end
  end
end
