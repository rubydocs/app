# frozen_string_literal: true

class CreateDocCollections < ActiveRecord::Migration[4.2]
  def change
    create_table :doc_collections do |t|
      t.string :slug, null: false
      t.datetime :generated_at, :uploaded_at
      t.timestamps
    end

    add_index :doc_collections, :slug, unique: true
  end
end
