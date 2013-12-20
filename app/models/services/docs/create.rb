module Services
  module Docs
    class Create < Services::Base
      def call(project_id, tag)
        project = Services::Projects::Find.call(project_id).first
        raise Error, "Project with ID #{project_id} not found." if project.nil?
        project.docs.create!(tag: tag)
      end
    end
  end
end
