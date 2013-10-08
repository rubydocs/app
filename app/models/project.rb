# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  git        :string(255)
#  tags       :text             default([])
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  has_many :docs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true

  def git_path
    Rails.root.join('projects', self.name)
  end
end
