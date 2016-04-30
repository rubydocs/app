# == Schema Information
#
# Table name: doc_collections
#
#  id             :integer          not null, primary key
#  generated_at   :datetime
#  generated_with :string(255)
#  slug           :string(255)      not null
#  uploaded_at    :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class DocCollection < ActiveRecord::Base
  include FriendlyId, LocalPath

  friendly_id :name, use: :slugged

  has_many :doc_collection_memberships, dependent: :destroy
  has_many :docs, through: :doc_collection_memberships

  validates :slug, presence: true
  validate do
    # When uploaded_at is present, generated_at must be present as well
  end

  scope :generated, -> { where{(generated_at != nil) & (uploaded_at == nil)} }
  scope :uploaded, -> { where{uploaded_at != nil} }

  accepts_nested_attributes_for :docs

  def name
    docs = self.docs.presence || self.doc_collection_memberships.map(&:doc)
    docs.map(&:name).join(', ')
  end

  def zipfile
    self.local_path.to_s << '.zip'
  end

  def generating?
    self.generated_at.nil?
  end

  def uploading?
    !self.generating? && self.uploaded_at.nil?
  end
end
