# frozen_string_literal: true

class AddGeneratedWithToDocCollections < ActiveRecord::Migration[4.2]
  def change
    add_column :doc_collections, :generated_with, :string
  end
end
