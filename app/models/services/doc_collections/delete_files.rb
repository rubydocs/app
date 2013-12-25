module Services
  module DocCollections
    class DeleteFiles < Services::Base
      def call(doc_collection)
        FileUtils.rm_rf doc_collection.local_path
        doc_collection
      end
    end
  end
end
