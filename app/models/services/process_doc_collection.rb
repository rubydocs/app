module Services
  class ProcessDocCollection < Services::Base
    def call(doc_collection_id)
      Services::DocCollections::GenerateDocCollection.call doc_collection_id
      Services::DocCollections::UploadDocCollection.perform_async :call, doc_collection_id
    end
  end
end
