class Doc < ApplicationRecord
  extend FriendlyId

  include LocalPath

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
    if self.tag.blank?
      raise 'Cannot determine doc name without a tag.'
    end
    if self.project.nil?
      raise 'Cannot determine doc name without a project.'
    end
    version = Projects::ConvertTagsToVersions.call([self.tag])[self.tag]
    if version.nil?
      raise "Could not convert tag #{self.tag} to version."
    end
    [self.project.name, version].join(' ')
  end
  alias :to_s :name
end

# == Schema Information
#
# Table name: docs
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  tag        :string
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#
