module Services
  module Projects
    class UpdateTagsForAll < Services::Base
      recurrence { daily.hour_of_day(*(0..23).to_a) }

      def call
        check_uniqueness!
        Project.find_each do |project|
          Services::Projects::UpdateTags.perform_async project.id
        end
      end
    end
  end
end
