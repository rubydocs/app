class AddFilePathsToDocCollections < ActiveRecord::Migration
  def change
    add_column :doc_collections, :file_paths, :text, array: true, default: [], null: false
  end
end
