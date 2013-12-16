class CreateDocCollections < ActiveRecord::Migration
  def change
    create_table :doc_collections do |t|
      t.string :url
      t.string :slug, null: false
      t.boolean :generating, default: true
      t.timestamps
    end

    add_index :doc_collections, :slug, unique: true
  end
end
