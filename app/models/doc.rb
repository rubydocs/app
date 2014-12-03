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

  def local_git_path
    Rails.root.join('files', 'doc_gits', self.slug)
  end

  def name
    raise 'Cannot determine doc name without a tag.' if self.tag.blank?
    raise 'Cannot determine doc name without a project.' if self.project.nil?
    version = Services::Projects::ConvertTagsToVersions.call([self.tag])[self.tag]
    raise "Could not convert tag #{self.tag} to version." if version.nil?
    [self.project.name, version].join(' ')
  end
end
