require 'open-uri'

module Services
  module DocCollections
    class PerformChecks < Services::Base
      def call
        check_uniqueness on_error: :return

        messages = []

        uploaded_doc_collections = Services::DocCollections::Find.call([], uploaded_at: true)
        not_found_uploaded_doc_collections = uploaded_doc_collections.select do |doc_collection|
          begin
            open "http://docs.rubydocs.org/#{doc_collection.slug}"
          rescue OpenURI::HTTPError
            true
          else
            false
          end
        end
        if not_found_uploaded_doc_collections.any?
          messages << "Couldn't find #{not_found_uploaded_doc_collections.size} doc collections that should have been uploaded: #{not_found_uploaded_doc_collections.map(&:slug).join(', ')}"
        end

        doc_collections_late_for_upload = Services::DocCollections::Find.call([], generated_before: 3.hours.ago, uploaded_at: nil)
        if doc_collections_late_for_upload.any?
          messages << "#{doc_collections_late_for_upload.size} doc collections are late for upload: #{doc_collections_late_for_upload.map(&:slug).join(', ')}"
        end

        if messages.any?
          Mailer.doc_collection_checks(messages).deliver
        end
      end
    end
  end
end

