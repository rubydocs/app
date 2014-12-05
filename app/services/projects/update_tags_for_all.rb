module Services
  module Projects
    class UpdateTagsForAll < Services::Base
      def call
        check_uniqueness on_error: :return
        Project.find_each do |project|
          Services::Projects::UpdateTags.call project.id
        end
      end
    end
  end
end
