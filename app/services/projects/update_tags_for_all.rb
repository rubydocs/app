require 'cloudflare'

module Projects
  class UpdateTagsForAll < Services::Base
    UNSTABLE_TAGS_REGEX = /rc|alpha|beta|pre/

    def call
      check_uniqueness on_error: :return
      Project.find_each do |project|
        Projects::UpdateTags.call project
        next unless latest_stable_tag = project.tags.keys.grep_v(UNSTABLE_TAGS_REGEX).first
        if doc = Docs::Find.call(project: project, tag: latest_stable_tag).first
          doc_collection = DocCollections::Find.call(docs: [doc]).first
        end
        case
        when doc_collection
          if doc_collection.uploaded?
            Cloudflare.kv_store project.slug, doc_collection.slug
          end
        when %w(Ruby Rails).include?(project.name)
          doc ||= Docs::Create.call(project.id, latest_stable_tag)
          DocCollections::Create.call([doc])
        end
      end
    end
  end
end
