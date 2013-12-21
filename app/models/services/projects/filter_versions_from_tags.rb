module Services
  module Projects
    class FilterVersionsFromTags < Services::Base
      def call(project)
        versions = project.tags.each_with_object({}) do |tag, hash|
          begin
            version = Services::Projects::ConvertTagToVersion.call(tag)
          rescue Services::Projects::ConvertTagToVersion::Error
            next
          end
          hash[tag] = version
        end
        Hash[*versions.sort_by(&:last).reverse.flatten]
      end
    end
  end
end
