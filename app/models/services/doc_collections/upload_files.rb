module Services
  module DocCollections
    class UploadFiles < Services::Base
      BATCH_SIZE = 100

      def call(doc_collection_id)
        doc_collection = DocCollection.where(id: doc_collection_id).first
        raise Error, "Doc collection with ID #{doc_collection_id} not found." if doc_collection.nil?

        s3 = AWS::S3.new
        bucket = s3.buckets[Settings.aws.bucket]

        # Check which files are already uploaded
        dir = File.expand_path('..', doc_collection.local_path)
        all_files = Dir.chdir(dir) do
          Dir[File.join(doc_collection.slug, '**', '*')]
        end
        uploaded_files = bucket.objects.with_prefix(doc_collection.slug).map(&:key)
        remaining_files = all_files - uploaded_files

        # Upload remaining files
        remaining_files.take(BATCH_SIZE).each do |file|
          if File.file?(file)
            content_type = MimeMagic.by_path(file)
            bucket.objects[file].write(file: file, content_type: content_type)
          end
          remaining_files.delete(file)
        end

        # Enqueue yourself if there are more files to upload
        if remaining_files.present?
          self.class.perform_async :call, doc_collection.id
          return
        end

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
