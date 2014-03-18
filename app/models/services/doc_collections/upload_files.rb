require 'aws/s3'

module Services
  module DocCollections
    class UploadFiles < Services::Base
      def call(doc_collection_id)
        doc_collection = Services::DocCollections::Find.call(doc_collection_id).first
        raise Error, "Doc collection #{doc_collection_id} not found." if doc_collection.nil?

        # Sync docs
        local_path = doc_collection.local_path.to_s
        local_path << '/' unless local_path.end_with?('/')
        remote_path = local_path.split('/').last << '/'
        s3cmd = Rails.root.join('lib', 's3cmd', 's3cmd')
        s3cmd_options = {
          access_key:          Settings.aws.key,
          secret_key:          Settings.aws.secret,
          verbose:             true,
          :'delete-removed' => true
        }
        s3cmd_args = s3cmd_options.map do |k, v|
          "--#{k}".tap do |option|
            option << "=#{v}" unless v == true
          end
        end
        result = system("#{s3cmd} sync #{s3cmd_args.join(' ')} #{local_path} s3://#{Settings.aws.bucket}/#{remote_path}")
        raise Error, "Sync ended with non-success error status: #{$?}" unless result

        # Upload zip
        s3 = AWS::S3.new
        bucket = s3.buckets[Settings.aws.bucket]
        object = bucket.objects[File.basename(doc_collection.zipfile)]
        # Follow symlinks
        file = Pathname.new(doc_collection.zipfile).realpath
        object.write(file)

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
