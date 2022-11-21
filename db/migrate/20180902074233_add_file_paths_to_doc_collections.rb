# frozen_string_literal: true

class AddFilePathsToDocCollections < ActiveRecord::Migration[4.2]
  def change
    add_column :doc_collections, :file_paths, :text, array: true, default: [], null: false
  end
end
