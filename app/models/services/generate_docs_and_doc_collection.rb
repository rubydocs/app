module Services
  class GenerateDocsAndDocCollection < Services::Base
    def call(doc_collection_id)
      doc_collection = DocCollection.where(id: doc_collection_id).first
      raise Error, "Doc collection with ID #{doc_collection_id} not found." if doc_collection.nil?

      # Create files for docs
      doc_collection.docs.each do |doc|
        begin
          Services::Docs::CreateFiles.call doc
        rescue Services::Docs::CreateFiles::FolderExistsError
        end
      end

      # Create doc collection files
      Services::DocCollections::CreateFiles.call doc_collection

      # Set generated_at timestamp
      doc_collection.generated_at = Time.now
      doc_collection.save!

      # Upload doc collection files to cloud
      Services::DocCollections::UploadFilesToCloud.call doc_collection

      # Set uploaded_at timestamp
      doc_collection.uploaded_at = Time.now
      doc_collection.save!

      doc_collection
    end
  end
end
