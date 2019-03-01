require 'aws-sdk-s3'

SitemapGenerator::Sitemap.adapter       = SitemapGenerator::AwsSdkAdapter.new(Settings.aws.bucket)
SitemapGenerator::Sitemap.sitemaps_host = 'https://s3.amazonaws.com/rubydocs'
SitemapGenerator::Sitemap.default_host  = "https://#{Settings.host}"
SitemapGenerator::Sitemap.create do
  # Only doc collections generated after Feb 20, 2018, are included in the sitemap.
  # This is the date the first doc collection was generated with sdoc 1.0.0.
  # That way the number of included doc collections will grow over time as new ones
  # are created and old ones are regenerated with newer generators.
  doc_collections = DocCollections::Find.call(
    uploaded_at:     true,
    generated_after: Date.new(2018, 2, 20),
    order:           'uploaded_at DESC'
  )
  doc_collections.find_each do |doc_collection|
    add "/d/#{doc_collection.slug}/", lastmod: doc_collection.uploaded_at, priority: 0.75
    # Ignore the file paths of doc collections with more than one doc.
    next if doc_collection.docs.size > 1
    DocCollections::FetchFilePaths.call(doc_collection).each do |file_path|
      add "/d/#{doc_collection.slug}/#{file_path}", lastmod: doc_collection.uploaded_at
    end
  end
end
