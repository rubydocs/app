module Services
  module DocCollections
    class ProcessSome < Services::Base
      def call
        check_uniqueness on_error: :return

        doc_collection_to_generate = Services::DocCollections::Find.call([], generated_at: nil).first || begin
          current_generator_version = Services::DocGenerators::Sdoc::GetVersion.call
          Services::DocCollections::Find.call([], generated_at_not: nil, generated_with_not: current_generator_version, order: 'generated_at').last
        end
        if doc_collection_to_generate
          Services::DocCollections::Generate.call doc_collection_to_generate
        end

        doc_collections_to_upload = Services::DocCollections::Find.call([], generated_at: true, uploaded_at: nil)
        if doc_collections_to_upload.any?
          Services::DocCollections::Upload.call doc_collections_to_upload.first
        end
      end
    end
  end
end
