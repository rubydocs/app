module PageHelper
  def project_versions(project)
    versions = Services::Projects::ConvertTagsToVersions.call(project.tags.keys)
    versions.delete_if do |tag, version|
      version.nil?
    end
    versions.map do |tag, version|
      ["#{version} (#{project.tags[tag].to_date})", tag, data: { version: version, date: project.tags[tag].to_date.to_s(:number) }]
    end
  end
end
