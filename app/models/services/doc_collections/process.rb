module Services
  module DocCollections
    class Process < Services::Base
      def call(doc_collection_id)
        doc_collection = DocCollection.where(id: doc_collection_id).first
        raise Error, "Doc collection with ID #{doc_collection_id} not found." if doc_collection.nil?

        # Create files for docs
        doc_collection.docs.each do |doc|
          begin
            Services::Docs::CreateFiles.call doc
          rescue Services::Docs::CreateFiles::CreatingInProgressError
            self.class.perform_in 1.minute, :call, doc_collection.id
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
        # TODO: Delete email notifications

        Services::DocCollections::UploadFiles.perform_async :call, doc_collection.id

        doc_collection
      end
    end
  end
end
