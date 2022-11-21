# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name, :git
      t.string :slug, null: false
      t.json :tags
      t.timestamps
    end

    add_index :projects, :slug, unique: true
  end
end
