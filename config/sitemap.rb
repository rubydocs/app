require 'aws-sdk'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(Settings.aws.bucket)
SitemapGenerator::Sitemap.default_host = "https://#{Settings.host}"
SitemapGenerator::Sitemap.create do
  DocCollections::Find.call(uploaded_at: true, order: 'uploaded_at DESC').find_each do |doc_collection|
    add "/d/#{doc_collection.slug}/", lastmod: doc_collection.uploaded_at, priority: 0.75
    DocCollections::FetchFilePaths.call(doc_collection).each do |file_path|
      add "/d/#{doc_collection.slug}/#{file_path}", lastmod: doc_collection.uploaded_at
    end
  end
end
