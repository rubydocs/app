module DocCollectionHelper
  def doc_collection_url(doc_collection)
    raise Error, "Doc collection #{doc_collection.id} is still being generated." if doc_collection.generating?
    if doc_collection.uploading?
      "http://#{Settings.host}/doc_collections/#{doc_collection.slug}/"
    else
      "http://#{Settings.docs_host}/#{doc_collection.slug}/"
    end
  end
end
