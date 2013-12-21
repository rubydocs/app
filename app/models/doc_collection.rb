# == Schema Information
#
# Table name: doc_collections
#
#  id           :integer          not null, primary key
#  url          :string(255)
#  slug         :string(255)      not null
#  generated_at :datetime
#  uploaded_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class DocCollection < ActiveRecord::Base
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  has_many :doc_collection_memberships, dependent: :destroy
  has_many :docs, through: :doc_collection_memberships

  validates :slug, presence: true

  accepts_nested_attributes_for :docs

  def name
    docs = self.docs.presence || self.doc_collection_memberships.map(&:doc)
    docs.map(&:name).join(', ')
  end

  def generating?
    self.generated_at.nil?
  end

  def uploading?
    self.uploaded_at.nil?
  end
end
