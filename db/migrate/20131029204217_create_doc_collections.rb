class CreateDocCollections < ActiveRecord::Migration
  def change
    create_table :doc_collections do |t|
      t.string :url

      t.timestamps
    end
  end
end
