SitemapGenerator::Sitemap.default_host = "https://#{Settings.host}"
SitemapGenerator::Sitemap.create do
  DocCollections::Find.call(uploaded_at: true).find_each do |doc_collection|
    add "/d/#{doc_collection.slug}/", lastmod: doc_collection.uploaded_at, priority: 0.75
    doc_collection.file_paths.each do |file_path|
      add "/d/#{doc_collection.slug}/#{file_path}", lastmod: doc_collection.uploaded_at
    end
  end
end
