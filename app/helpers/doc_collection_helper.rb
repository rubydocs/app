module DocCollectionHelper
  def docs_host(doc_collection)
    if doc_collection.uploading?
      "/doc_collections/#{doc_collection.slug}"
    else
      "http://#{Settings.docs_host}/#{doc_collection.slug}"
    end
  end
end
