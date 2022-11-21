# frozen_string_literal: true

class DeleteDocCollectionsFilePaths < ActiveRecord::Migration[4.2]
  def change
    remove_column :doc_collections, :file_paths
  end
end
