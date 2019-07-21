require 'aws-sdk-s3'

module DocCollections
  class FetchFilePaths < Services::Base
    def call(doc_collection)
      cache_key = [
        'doc_collection_file_paths',
        doc_collection.id,
        doc_collection.uploaded_at.iso8601
      ].join(':')
      Rails.cache.fetch cache_key do
        regex_prefix = if doc_collection.docs.size > 1
          "(#{doc_collection.docs.map { |doc| Regexp.escape doc.name }.join('|')})/"
        end
        bucket = Aws::S3::Resource.new.bucket(ENV.fetch('AWS_BUCKET'))
        bucket.objects(prefix: "#{doc_collection.slug}/").map do |object|
          object.key.sub(%r(\A#{doc_collection.slug}/), '')
        end.grep(/\A#{regex_prefix}(files|classes)/)
      end
    end
  end
end
