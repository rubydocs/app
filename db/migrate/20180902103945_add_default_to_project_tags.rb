class AddDefaultToProjectTags < ActiveRecord::Migration
  def up
    change_column_default :projects, :tags, {}
  end

  def down
    change_column_default :projects, :tags, nil
  end
end
