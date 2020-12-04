require 'net/sftp'

module DocCollections
  class Upload < Services::Base
    SyncError = Class.new(Error)

    def call(doc_collection)
      check_uniqueness doc_collection.id
      if doc_collection.generating?
        raise Error, "Doc collection #{doc_collection.name} is not generated yet."
      end
      unless File.exist?(doc_collection.local_path) && Dir[File.join(doc_collection.local_path, '*')].present?
        raise Error, "Doc collection #{doc_collection.name} local path doesn't exist or is empty."
      end

      # Sync docs
      local_path = doc_collection.local_path.to_s
      unless local_path.end_with?('/')
        local_path << '/'
      end
      remote_path = local_path.split('/').last << '/'
      s3cmd = Rails.root.join('lib', 's3cmd', 's3cmd')
      s3cmd_options = {
        access_key:              ENV.fetch('AWS_ACCESS_KEY_ID'),
        secret_key:              ENV.fetch('AWS_SECRET_ACCESS_KEY'),
        quiet:                   true,
        :'delete-removed'     => true,
        :'no-preserve'        => true,
        :'reduced-redundancy' => true,
        :'acl-public'         => true
      }
      s3cmd_args = s3cmd_options.map do |k, v|
        "--#{k}".tap do |option|
          unless v == true
            option << "=#{v}"
          end
        end
      end
      10.tries on: SyncError do
        command = "#{s3cmd} sync #{s3cmd_args.join(' ')} #{local_path} s3://#{ENV.fetch('AWS_BUCKET')}/#{remote_path}"
        result = system(command)
        unless result
          raise SyncError, "Sync ended with non-success error status: #{$?}, command: #{command}"
        end
      end

      # Upload zip
      # unless File.exist?(doc_collection.zipfile)
      #   raise Error, "Doc collection #{doc_collection.name} zipfile doesn't exist."
      # end
      # # Follow symlinks
      # local_file = Pathname.new(doc_collection.zipfile).realpath.to_s
      # remote_file = File.join('public_html', File.basename(doc_collection.zipfile))
      # Net::SFTP.start(ENV.fetch('ZIP_FTP_HOST'), ENV.fetch('ZIP_FTP_USERNAME'), password: ENV.fetch('ZIP_FTP_PASSWORD')) do |sftp|
      #   10.tries on: [IOError, Net::SSH::Disconnect] do
      #     sftp.upload! local_file, remote_file
      #   end
      # end

      # Set uploaded_at timestamp
      doc_collection.uploaded_at = Time.now
      doc_collection.save!

      # Regenerate sitemap
      Rails.application.load_tasks
      Rake.application['sitemap:refresh'].invoke

      # Delete doc collection files
      DocCollections::DeleteFiles.call doc_collection

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
