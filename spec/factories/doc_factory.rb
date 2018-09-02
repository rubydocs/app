FactoryBot.define do
  factory :doc do
    association :project
    tag         { project.tags.sample }
  end
end

# == Schema Information
#
# Table name: docs
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  tag        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#
