module Services
  module Projects
    class UpdateTagsForAll < Services::Base
      def call
        check_uniqueness!
        Project.find_each do |project|
          Services::Projects::UpdateTags.perform_async project.id
        end
      end
    end
  end
end
