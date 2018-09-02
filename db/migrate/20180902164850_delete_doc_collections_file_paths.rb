class DeleteDocCollectionsFilePaths < ActiveRecord::Migration
  def change
    remove_column :doc_collections, :file_paths
  end
end
