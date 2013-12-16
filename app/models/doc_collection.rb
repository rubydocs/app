# == Schema Information
#
# Table name: doc_collections
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  slug       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  generating :boolean          default(TRUE)
#

class DocCollection < ActiveRecord::Base
  PATH = Rails.root.join('doc_collections')

  include FriendlyId
  friendly_id :name, use: :slugged

  has_many :doc_collection_memberships, dependent: :destroy
  has_many :docs, through: :doc_collection_memberships

  validates :slug, presence: true

  accepts_nested_attributes_for :docs

  def name
    docs = self.docs.presence || self.doc_collection_memberships.map(&:doc)
    docs.map(&:name).sort.join(', ')
  end

  def local_path
    File.join(PATH, self.slug)
  end
end
