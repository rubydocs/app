FactoryBot.define do
  factory :doc_collection do
    docs { build_list(:doc, 1) }
  end
end

# == Schema Information
#
# Table name: doc_collections
#
#  id             :integer          not null, primary key
#  file_paths     :text             default([]), not null, is an Array
#  generated_at   :datetime
#  generated_with :string(255)
#  slug           :string(255)      not null
#  uploaded_at    :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
