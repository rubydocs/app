class CreateDocCollectionMemberships < ActiveRecord::Migration
  def change
    create_table :doc_collection_memberships do |t|
      t.references :doc
      t.references :doc_collection
    end

    add_index :doc_collection_memberships, %i(doc_id doc_collection_id), unique: true, name: 'index_doc_collection_m_on_doc_id_and_doc_collection_id'
  end
end
