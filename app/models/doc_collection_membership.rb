class DocCollectionMembership < ApplicationRecord
  belongs_to :doc
  belongs_to :doc_collection

  validates :doc, presence: true
  validates :doc_id, uniqueness: { scope: :doc_collection_id }
end
