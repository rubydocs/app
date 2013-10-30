# == Schema Information
#
# Table name: docs
#
#  id         :integer          not null, primary key
#  tag        :string(255)
#  url        :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Doc < ActiveRecord::Base
  belongs_to :project
  has_many :doc_collection_associations
  has_many :doc_collections, through: :doc_collection_associations

  validates :tag, presence: true, uniqueness: { scope: :project_id }, inclusion: { in: ->(doc) { doc.project.tags }, if: -> { self.project.present? } }
  validates :url, uniqueness: { allow_blank: true }
  validates :project, presence: true

  attr_accessor :include
end
