module DocCollections
  class Create < Services::Base
    def call(docs)
      doc_collection = DocCollection.new
      docs.each do |doc|
        # Cannot use doc_collection.doc_collection_memberships.build() here, otherwise validations fail
        doc_collection.doc_collection_memberships << DocCollectionMembership.new(doc: doc, doc_collection: doc_collection)
      end
      doc_collection.save!
      doc_collection
    end
  end
end
