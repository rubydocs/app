class AddGeneratedWithToDocCollections < ActiveRecord::Migration
  def change
    add_column :doc_collections, :generated_with, :string
  end
end
