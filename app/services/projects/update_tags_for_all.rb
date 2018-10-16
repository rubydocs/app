require 'cloudflare'

module Projects
  class UpdateTagsForAll < Services::Base
    UNSTABLE_TAGS_REGEX = /rc|alpha|beta|pre/

    def call
      check_uniqueness on_error: :return
      Project.find_each do |project|
        Projects::UpdateTags.call project
        next unless latest_stable_tag = project.tags.keys.grep_v(UNSTABLE_TAGS_REGEX).first
        next unless doc               = Docs::Find.call(project: project, tag: latest_stable_tag).first
        next unless doc_collection    = DocCollections::Find.call(docs: [doc]).first
        next unless doc_collection.uploaded?
        Cloudflare.store project.slug, doc_collection.slug
      end
    end
  end
end
