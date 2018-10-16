module DocCollections
  class Generate < Services::Base
    def call(doc_collection)
      check_uniqueness doc_collection.id

      # Create files for docs
      doc_collection.docs.each do |doc|
        unless File.exist?(doc.local_path)
          Docs::CreateGitFiles.call doc
          Docs::CreateFiles.call doc
          Docs::DeleteGitFiles.call doc
        end
      end

      DocCollections::CreateFiles.call doc_collection

      doc_collection.docs.each do |doc|
        Docs::DeleteFiles.call doc
      end

      doc_collection.generated_with = DocGenerators::Sdoc::GetVersion.call
      doc_collection.generated_at = Time.now
      # Set uploaded_at to nil, in case it was set before,
      # to make sure the doc collection is uploaded again.
      doc_collection.uploaded_at = nil
      doc_collection.save!

      doc_collection
    end
  end
end
