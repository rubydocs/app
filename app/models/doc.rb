# == Schema Information
#
# Table name: docs
#
#  id         :integer          not null, primary key
#  tag        :string(255)
#  url        :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Doc < ActiveRecord::Base
  belongs_to :project

  validates :tag, presence: true, uniqueness: { scope: :project_id }, inclusion: { in: ->(doc) { doc.project.tags }, if: ->(doc) { doc.project.present? } }
  validates :url, uniqueness: { allow_blank: true }
  validates :project, presence: true
end
