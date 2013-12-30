module PageHelper
  def project_versions(project)
    versions = Services::Projects::ConvertTagsToVersions.call(project.tags.keys)
    versions.each_with_object({}) do |(tag, version), hash|
      hash["#{version} (#{project.tags[tag].to_date})"] = tag
    end
  end
end
