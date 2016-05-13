class AddLinksToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :links, :text, array: true, default: [], null: false
  end
end
