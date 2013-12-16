class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, :git
      t.string :slug, null: false
      t.text :tags, array: true, default: []
      t.timestamps
    end

    add_index :projects, :slug, unique: true
  end
end
