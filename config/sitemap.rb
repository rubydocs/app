require 'aws-sdk'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(Settings.aws.bucket)
SitemapGenerator::Sitemap.default_host = "https://#{Settings.host}"
SitemapGenerator::Sitemap.create do
  # Let's include not all doc collections at once but only those generated after Feb 21, 2018.
  # This is the date the first doc collection was generated with sdoc 1.0.0.
  # That way the number of included doc collections will grow over time as new ones
  # are created and old ones are regenerated with newer generators.
  date = Date.new(2018, 2, 21)
  DocCollections::Find.call(uploaded_at: true, generated_after: date, order: 'uploaded_at DESC').find_each do |doc_collection|
    add "/d/#{doc_collection.slug}/", lastmod: doc_collection.uploaded_at, priority: 0.75
    DocCollections::FetchFilePaths.call(doc_collection).each do |file_path|
      add "/d/#{doc_collection.slug}/#{file_path}", lastmod: doc_collection.uploaded_at
    end
  end
end
