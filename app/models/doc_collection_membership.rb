# == Schema Information
#
# Table name: doc_collection_memberships
#
#  id                :integer          not null, primary key
#  doc_id            :integer
#  doc_collection_id :integer
#

class DocCollectionMembership < ActiveRecord::Base
  belongs_to :doc
  belongs_to :doc_collection

  validates :doc, presence: true
  # TODO: Cannot create doc collection when this validation is active...
  # validates :doc_collection, presence: true
  validates :doc_id, uniqueness: { scope: :doc_collection_id }
end
