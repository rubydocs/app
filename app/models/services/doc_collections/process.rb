module Services
  module DocCollections
    class Process < Services::Base
      def call(doc_collection_id)
        doc_collection = DocCollection.where(id: doc_collection_id).first
        raise Error, "Doc collection #{doc_collection_id} not found." if doc_collection.nil?
        raise Error, "Doc collection #{doc_collection.name} is already generated." unless doc_collection.generating?

        # Create files for docs
        doc_collection.docs.each do |doc|
          begin
            Services::Docs::CreateFiles.call doc
          rescue Services::Docs::CreateFiles::CreatingInProgressError
            log "Doc files for #{doc.name} are already being created, trying again in one minute."
            self.class.perform_in 1.minute, :call, doc_collection.id
            return
          rescue Services::Docs::CreateFiles::FilesExistsError
            log "Doc files for #{doc.name} already exist."
            next
          end
        end

        # Create doc collection files
        Services::DocCollections::CreateFiles.call doc_collection

        # Set generated_at timestamp
        doc_collection.generated_at = Time.now
        doc_collection.save!
        log "Doc collection generated at #{doc_collection.generated_at}"

        # Send notifications
        emails = EmailNotification.by_doc_collection(doc_collection).map(&:email)
        if emails.present?
          Mailer.doc_collection_generated(doc_collection, emails).deliver!
          log "Email notification sent to #{emails.count} recipients: #{emails.join(', ')}"
          EmailNotification.delete(doc_collection)
        end

        Services::DocCollections::UploadFiles.perform_async :call, doc_collection.id unless Rails.env.development?

        doc_collection
      end
    end
  end
end
