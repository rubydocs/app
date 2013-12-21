module Services
  module DocCollections
    class UploadFilesToCloud < Services::Base
      def call(doc_collection)
        s3 = AWS::S3.new
        bucket = s3.buckets[Settings.aws.bucket]
        dir = File.expand_path('..', doc_collection.local_path)
        Dir.chdir dir do
          Dir[File.join(doc_collection.slug, '**', '*')].each do |path|
            next unless File.file?(path)
            bucket.objects[path].write(file: path)
          end
        end
        doc_collection
      end
    end
  end
end
