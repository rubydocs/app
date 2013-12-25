module Services
  module DocCollections
    class UploadFiles < Services::Base
      def call(doc_collection)
        s3 = AWS::S3.new
        bucket = s3.buckets[Settings.aws.bucket]
        dir = File.expand_path('..', doc_collection.local_path)
        Dir.chdir dir do
          Dir[File.join(doc_collection.slug, '**', '*')].each do |path|
            next unless File.file?(path)
            content_type = MimeMagic.by_path(path)
            bucket.objects[path].write(file: path, content_type: content_type)
          end
        end
        doc_collection
      end
    end
  end
end
