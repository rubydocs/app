module Services
  class UploadDocCollection < Services::Base
    def call(doc_collection_id)
      doc_collection = DocCollection.where(id: doc_collection_id).first
      raise Error, "Doc collection with ID #{doc_collection_id} not found." if doc_collection.nil?

      # Upload doc collection files to cloud
      Services::DocCollections::UploadFiles.call doc_collection

      # Set uploaded_at timestamp
      doc_collection.uploaded_at = Time.now
      doc_collection.save!

      # Delete doc collection files
      Services::DocCollections::DeleteFiles.call doc_collection

      doc_collection
    end
  end
end
