module PageHelper
  def project_versions(project)
    versions = Services::Projects::ConvertTagsToVersions.call(project.tags)
    Hash[*versions.sort_by(&:last).reverse.flatten]
  end
end
