module Services
  module DocCollections
    class UploadFiles < Services::Base
      def call(doc_collection_id)
        doc_collection = Services::DocCollections::Find.call(doc_collection_id).first
        raise Error, "Doc collection #{doc_collection_id} not found." if doc_collection.nil?

        Services::SyncFiles.call doc_collection.local_path

        # Set uploaded_at timestamp
        doc_collection.uploaded_at = Time.now
        doc_collection.save!

        # Delete doc collection files
        Services::DocCollections::DeleteFiles.call doc_collection

        doc_collection
      end
    end
  end
end
