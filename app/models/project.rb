class Project < ApplicationRecord
  extend FriendlyId

  include LocalPath

  friendly_id :name, use: :slugged

  has_many :docs, dependent: :destroy
  has_many :doc_collections, through: :docs

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  git        :string
#  links      :text             default([]), not null, is an Array
#  name       :string
#  slug       :string           not null
#  tags       :json
#  created_at :datetime
#  updated_at :datetime
#
