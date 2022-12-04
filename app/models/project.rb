class Project < ApplicationRecord
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  has_many :docs, dependent: :destroy
  has_many :doc_collections, through: :docs

  validates :name, presence: true, uniqueness: true
  validates :git, presence: true, uniqueness: true
end
