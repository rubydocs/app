module PageHelper
  def project_versions(project)
    versions = Services::Projects::ConvertTagsToVersions.call(project.tags)
    versions.reject! { |k, v| v.nil? }
    Hash[*versions.sort_by(&:last).reverse.flatten].invert
  end
end
