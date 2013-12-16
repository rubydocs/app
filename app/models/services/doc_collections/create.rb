module Services
  module DocCollections
    class Create < Services::Base
      def call(docs)
        doc_collection = DocCollection.new
        docs.each do |doc|
          doc_collection.doc_collection_memberships.build doc_id: doc.id
        end
        raise doc_collection.doc_collection_memberships.map(&:errors).inspect unless doc_collection.doc_collection_memberships.all?(&:valid?)
        doc_collection.save!
        doc_collection
      end
    end
  end
end
