class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, :git
      t.text :tags, array: true, default: []

      t.timestamps
    end
  end
end
