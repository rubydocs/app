module Projects
  class UpdateTagsForAll < Services::Base
    UNSTABLE_TAGS_REGEX = /rc|alpha|beta|pre/

    def call
      check_uniqueness on_error: :return
      Project.find_each do |project|
        Projects::UpdateTags.call project
        if latest_stable_tag = project.tags.keys.grep_v(UNSTABLE_TAGS_REGEX).first
          Cloudflare.store project.slug, latest_stable_tag
        end
      end
    end
  end
end
