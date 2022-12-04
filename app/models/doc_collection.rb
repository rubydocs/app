class DocCollection < ApplicationRecord
  extend FriendlyId

  include LocalPath

  friendly_id :name, use: :slugged

  has_many :doc_collection_memberships, dependent: :destroy
  has_many :docs, through: :doc_collection_memberships

  validates :slug, presence: true
  validates :generated_with, presence: { if: -> { generated_at } }
  validates :generated_at, presence: { if: -> { uploaded_at } }

  scope :generated, -> { where{(generated_at != nil) & (uploaded_at == nil)} }
  scope :uploaded, -> { where{uploaded_at != nil} }

  accepts_nested_attributes_for :docs

  def name
    docs = self.docs.presence || self.doc_collection_memberships.map(&:doc)
    docs.map(&:name).join(' & ')
  end
  alias :to_s :name

  def zipfile
    self.local_path.to_s << '.zip'
  end

  def generating?
    self.generated_at.nil?
  end

  def uploading?
    !self.generating? && self.uploaded_at.nil?
  end

  def uploaded?
    !!uploaded_at
  end
end

# == Schema Information
#
# Table name: doc_collections
#
#  id             :integer          not null, primary key
#  generated_at   :datetime
#  generated_with :string
#  slug           :string           not null
#  uploaded_at    :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
