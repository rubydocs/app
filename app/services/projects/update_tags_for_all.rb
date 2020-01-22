require 'cloudflare'

module Projects
  class UpdateTagsForAll < Services::Base
    UNSTABLE_TAGS_REGEX    = /rc|alpha|beta|pre/
    LAST_SUCCESS_CACHE_KEY = 'update_tags_for_all_last_success'.freeze

    def call
      check_uniqueness on_error: :return

      now = Time.current

      Project.find_each do |project|
        Projects::UpdateTags.call project

        next unless latest_stable_tag = project.tags.keys.grep_v(UNSTABLE_TAGS_REGEX).first

        if doc = Docs::Find.call(project: project, tag: latest_stable_tag).first
          doc_collection = DocCollections::Find.call(docs: [doc]).first
        end

        case
        when doc_collection
          if doc_collection.uploaded?
            begin
              Cloudflare.kv_store project.slug, doc_collection.slug
            rescue Cloudflare::Error
              last_success = get_last_success
              if !last_success || last_success < 1.day.ago
                raise Error, "Could not store doc collection #{doc_collection.slug} for #{project.slug}."
              end
            end
          end
        when %w(Ruby Rails).include?(project.name)
          doc ||= Docs::Create.call(project.id, latest_stable_tag)
          DocCollections::Create.call([doc])
        end
      end

      set_last_success now
    end

    private

      def get_last_success
        if time = Redis.current.get(LAST_SUCCESS_CACHE_KEY)
          Time.zone.parse time
        end
      end

      def set_last_success(time)
        Redis.current.set(LAST_SUCCESS_CACHE_KEY, time.iso8601)
      end
  end
end
