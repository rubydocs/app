module DocCollections
  class DeleteFiles < Services::Base
    def call(doc_collection)
      [doc_collection.local_path, doc_collection.zipfile].each do |path|
        FileUtils.rm_rf path
      end
      doc_collection
    end
  end
end
