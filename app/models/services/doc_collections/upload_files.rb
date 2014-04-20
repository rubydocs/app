require 'aws/s3'
require 'net/sftp'

module Services
  module DocCollections
    class UploadFiles < Services::Base
      SyncError = Class.new(Error)

      def call(doc_collection_id)
        doc_collection = Services::DocCollections::Find.call(doc_collection_id).first
        raise Error, "Doc collection #{doc_collection_id} not found." if doc_collection.nil?
        raise Error, "Doc collection #{doc_collection.name} is not generated yet." if doc_collection.generating?
        raise Error, "Doc collection #{doc_collection.name} local path doesn't exist or is empty." unless File.exist?(doc_collection.local_path) && Dir[File.join(doc_collection.local_path, '*')].present?

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
        3.tries on: SyncError do
          result = system("#{s3cmd} sync #{s3cmd_args.join(' ')} #{local_path} s3://#{Settings.aws.bucket}/#{remote_path}")
          raise SyncError, "Sync ended with non-success error status: #{$?}" unless result
        end

        # Upload zip
        raise Error, "Doc collection #{doc_collection.name} zipfile doesn't exist." unless File.exist?(doc_collection.zipfile)
        # Follow symlinks
        local_file = Pathname.new(doc_collection.zipfile).realpath
        remote_file = File.join('public_html', File.basename(doc_collection.zipfile))
        Net::SFTP.start(Settings.zip_storage.ftp_host, Settings.zip_storage.ftp_username, password: Settings.zip_storage.ftp_password) do |sftp|
          sftp.upload! local_file, remote_file
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
