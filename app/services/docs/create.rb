module Docs
  class Create < Baseline::Service
    def call(project_id, tag)
      project = Projects::Find.call(project_id).first
      if project.nil?
        raise Error, "Project with ID #{project_id} not found."
      end
      project.docs.create!(tag: tag)
    end
  end
end
