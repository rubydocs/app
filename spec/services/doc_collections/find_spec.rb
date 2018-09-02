require 'spec_helper'

describe DocCollections::Find do
  describe 'filtering by docs' do
    it 'works as expected' do
      doc_1, doc_2, doc_3 = create_list(:doc, 3)
      doc_collection_1 = create(:doc_collection, docs: [doc_1, doc_2, doc_3])
      doc_collection_2 = create(:doc_collection, docs: [doc_1, doc_2])
      doc_collection_3 = create(:doc_collection, docs: [doc_2, doc_3])
      doc_collections = DocCollections::Find.call(docs: [doc_1, doc_2])
      expect(doc_collections).to eq([doc_collection_2])
    end
  end
end
