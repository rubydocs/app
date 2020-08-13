# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  git        :string(255)
#  links      :text             default([]), not null, is an Array
#  name       :string(255)
#  slug       :string(255)      not null
#  tags       :json
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  has_many :docs, dependent: :destroy
  has_many :doc_collections, through: :docs

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true
end
