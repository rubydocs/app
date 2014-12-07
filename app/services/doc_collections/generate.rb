module Services
  module DocCollections
    class Generate < Services::Base
      def call(id_or_object)
        doc_collection = find_object(id_or_object)
        check_uniqueness doc_collection.id
        raise Error, "Doc collection #{doc_collection.name} is already generated." unless doc_collection.generating?

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

        doc_collection.generated_at = Time.now
        doc_collection.save!

        # Send notifications
        unless Rails.env.development?
          emails = EmailNotification.by_doc_collection(doc_collection).map(&:email)
          if emails.present?
            Mailer.doc_collection_generated(doc_collection, emails).deliver!
            EmailNotification.delete(doc_collection)
          end
        end

        doc_collection
      end
    end
  end
end
