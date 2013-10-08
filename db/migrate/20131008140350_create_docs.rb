class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :tag, :url
      t.references :project

      t.timestamps
    end
  end
end
