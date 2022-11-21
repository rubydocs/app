module Projects
  class Create < Baseline::Service
    def call(attributes)
      project = Project.create!(attributes)
      Projects::Clone.call(project)
      Projects::UpdateTags.call(project)
      # Reload project so that tags are visible.
      project.reload
    end
  end
end
