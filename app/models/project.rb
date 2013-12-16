# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  git        :string(255)
#  slug       :string(255)      not null
#  tags       :text             default([])
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  PATH = Rails.root.join('projects')

  include FriendlyId
  friendly_id :name, use: :slugged

  has_many :docs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true

  def local_path
    File.join(PATH, self.slug)
  end
end
