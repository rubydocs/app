module DocCollections
  class ProcessSome < Services::Base
    def call
      check_uniqueness on_error: :return

      doc_collection_to_generate = DocCollections::Find.call(generated_at: nil, order: 'created_at').first# || begin
      #   current_generator_version = DocGenerators::Sdoc::GetVersion.call
      #   DocCollections::Find.call(generated_at_not: nil, generated_with_not: [current_generator_version, 'ignore'], order: 'generated_at').last
      # end
      if doc_collection_to_generate
        begin
          DocCollections::Generate.call doc_collection_to_generate
        rescue DocCollections::Generate::Error
          fail %(Error generation doc collection "#{doc_collection_to_generate}")
        end
      end

      if doc_collection_to_upload = DocCollections::Find.call(generated_at: true, uploaded_at: nil, order: 'generated_at').first
        DocCollections::Upload.call doc_collection_to_upload
      end
    end
  end
end
