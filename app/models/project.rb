# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  git        :string(255)
#  slug       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  tags       :json
#

class Project < ActiveRecord::Base
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  has_many :docs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true
end
