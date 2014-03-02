module Services
  class SyncFiles < Services::Base
    def call(path)
      local_path = path.to_s
      local_path << '/' unless local_path.end_with?('/')
      remote_path = local_path.split('/').last << '/'
      result = system("s3cmd sync --verbose --delete-removed #{local_path} s3://#{Settings.aws.bucket}/#{remote_path}")
      raise Error, "Sync ended with non-success error status: #{$?}" unless result
    end
  end
end
