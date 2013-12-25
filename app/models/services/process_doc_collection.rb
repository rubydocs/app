module Services
  class ProcessDocCollection < Services::Base
    def call(doc_collection_id)
      doc_collection = DocCollection.where(id: doc_collection_id).first
      raise Error, "Doc collection with ID #{doc_collection_id} not found." if doc_collection.nil?

      # Create files for docs
      doc_collection.docs.each do |doc|
        begin
          Services::Docs::CreateFiles.call doc
        rescue Services::Docs::CreateFiles::CreatingInProgressError
          self.class.perform_in 1.minute, doc_collection_id
          return
        rescue Services::Docs::CreateFiles::FilesExistsError
          next
        end
      end

      # Create doc collection files
      Services::DocCollections::CreateFiles.call doc_collection

      # Set generated_at timestamp
      doc_collection.generated_at = Time.now
      doc_collection.save!

      # Send notifications
      emails = EmailNotification.by_doc_collection(doc_collection).map(&:email)
      Mailer.doc_collection_generated(doc_collection, emails).deliver! if emails.present?

      unless Rails.env.development?
        # Upload doc collection files to cloud
        Services::DocCollections::UploadFiles.call doc_collection

        # Set uploaded_at timestamp
        doc_collection.uploaded_at = Time.now
        doc_collection.save!

        # Delete doc collection files
        Services::DocCollections::DeleteFiles.call doc_collection
      end

      doc_collection
    end
  end
end
