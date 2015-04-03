module Services
  module DocCollections
    class ProcessSome < Services::Base
      def call
        check_uniqueness on_error: :return

        doc_collections_to_generate = Services::DocCollections::Find.call([], generated_at: nil)
        if doc_collections_to_generate.any?
          Services::DocCollections::Generate.call doc_collections_to_generate.first
        end

        doc_collections_to_upload = Services::DocCollections::Find.call([], generated_at: true, uploaded_at: nil)
        if doc_collections_to_upload.any?
          Services::DocCollections::Upload.call doc_collections_to_upload.first
        end
      end
    end
  end
end
