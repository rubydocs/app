# frozen_string_literal: true

class CreateDocs < ActiveRecord::Migration[4.2]
  def change
    create_table :docs do |t|
      t.string :tag
      t.string :slug, null: false
      t.references :project
      t.timestamps
    end

    add_index :docs, :slug, unique: true
  end
end
