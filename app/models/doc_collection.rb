# == Schema Information
#
# Table name: doc_collections
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class DocCollection < ActiveRecord::Base
  has_many :doc_collection_associations
  has_many :docs, through: :doc_collection_associations

  accepts_nested_attributes_for :docs
end
