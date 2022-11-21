# frozen_string_literal: true

class AddDefaultToProjectTags < ActiveRecord::Migration[4.2]
  def up
    change_column_default :projects, :tags, {}
  end

  def down
    change_column_default :projects, :tags, nil
  end
end
