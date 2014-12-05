module Services
  module DocCollections
    class Generate < Services::Base
      def call(id_or_object)
        doc_collection = find_object(id_or_object)
        check_uniqueness doc_collection.id
        raise Error, "Doc collection #{doc_collection.name} is already generated." unless doc_collection.generating?

        # Create files for docs
        doc_collection.docs.each do |doc|
          log "Creating files for doc #{doc.name}."

          begin
            Services::Docs::CreateGitFiles.call doc
          rescue Services::Docs::CreateGitFiles::NotUniqueError
            log "Doc git files for another set of #{doc.project.name} docs are already being created, trying again in one minute."
            self.class.perform_in 1.minute, doc_collection.id
            return
          end

          begin
            Services::Docs::CreateFiles.call doc
          rescue Services::Docs::CreateFiles::FilesExistsError
            log "Doc files for #{doc.name} already exist."
            next
          end
        end

        # Create doc collection files
        log "Creating files for doc collection #{doc_collection.name}."
        Services::DocCollections::CreateFiles.call doc_collection

        # Set generated_at timestamp
        doc_collection.generated_at = Time.now
        doc_collection.save!
        log "Doc collection generated at #{doc_collection.generated_at}"

        # Send notifications
        unless Rails.env.development?
          emails = EmailNotification.by_doc_collection(doc_collection).map(&:email)
          if emails.present?
            Mailer.doc_collection_generated(doc_collection, emails).deliver!
            log "Email notification sent to #{emails.count} recipients: #{emails.join(', ')}"
            EmailNotification.delete(doc_collection)
          end
        end

        doc_collection
      end
    end
  end
end
