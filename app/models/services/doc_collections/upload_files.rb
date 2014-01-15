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
        Dir.chdir dir
        all_files = Dir[File.join(doc_collection.slug, '**', '*')].select do |file|
          File.file?(file)
        end
        uploaded_files = bucket.objects.with_prefix(doc_collection.slug).map(&:key)
        remaining_files = all_files - uploaded_files

        # Upload remaining files
        remaining_files.take(BATCH_SIZE).each do |file|
          content_type = MimeMagic.by_path(file).to_s
          bucket.objects[file].write(file: file, content_type: content_type)
          remaining_files.delete(file)
        end

        # Enqueue yourself if there are more files to upload
        if remaining_files.present?
          self.class.perform_async doc_collection.id
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
