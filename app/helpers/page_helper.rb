module PageHelper
  def project_versions(project)
    Services::Projects::FilterVersionsFromTags.call(project).invert
  end
end
