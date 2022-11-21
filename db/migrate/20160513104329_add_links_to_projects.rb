# frozen_string_literal: true

class AddLinksToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :links, :text, array: true, default: [], null: false
  end
end
