class CreateDocCollectionAssociations < ActiveRecord::Migration
  def change
    create_table :doc_collection_associations do |t|
      t.references :doc, :doc_collection
    end

    add_index :doc_collection_associations, :doc_id
    add_index :doc_collection_associations, :doc_collection_id
  end
end
