module Services
  class GenerateDocsAndDocCollection < Services::Base
    def call(docs, doc_collection)
      # Create files for docs
      docs.each do |doc|
        begin
          Services::Docs::CreateFiles.call doc
        rescue Services::Docs::CreateFiles::FolderExistsError
        end
      end

      # Add docs to doc collections, create files and sync to cloud
      Services::DocCollections::CreateFiles.call doc_collection
      Services::DocCollections::SyncToCloud.call doc_collection

      # Set "generating" to false
      doc_collection.generating = false
      doc_collection.save!

      doc_collection
    end
  end
end
