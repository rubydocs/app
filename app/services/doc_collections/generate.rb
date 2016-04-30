module Services
  module DocCollections
    class Generate < Services::Base
      def call(id_or_object)
        doc_collection = find_object(id_or_object)

        check_uniqueness doc_collection.id

        # Create files for docs
        doc_collection.docs.each do |doc|
          unless File.exist?(doc.local_path)
            Services::Docs::CreateGitFiles.call doc
            Services::Docs::CreateFiles.call doc
            Services::Docs::DeleteGitFiles.call doc
          end
        end

        Services::DocCollections::CreateFiles.call doc_collection

        doc_collection.docs.each do |doc|
          Services::Docs::DeleteFiles.call doc
        end

        doc_collection.generated_with = Services::DocGenerators::Sdoc::GetVersion.call
        doc_collection.generated_at = Time.now
        # Set uploaded_at to nil, in case it was set before,
        # to make sure the doc collection is uploaded again.
        doc_collection.uploaded_at = nil
        doc_collection.save!

        doc_collection
      end
    end
  end
end
