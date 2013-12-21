# == Schema Information
#
# Table name: docs
#
#  id         :integer          not null, primary key
#  tag        :string(255)
#  slug       :string(255)      not null
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Doc < ActiveRecord::Base
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  belongs_to :project
  has_many :doc_collection_memberships, dependent: :destroy
  has_many :doc_collections, through: :doc_collection_memberships

  validates :tag, presence: true, uniqueness: { scope: :project_id }, inclusion: { in: ->(doc) { doc.project.tags }, if: -> { self.project.present? } }
  validates :project, presence: true

  attr_accessor :include

  def name
    [self.project.name, Services::Projects::ConvertTagToVersion.call(self.tag)].join(' ')
  end
end
