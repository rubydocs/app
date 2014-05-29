FactoryGirl.define do
  factory :doc_collection do
    docs { build_list(:doc, 1) }
  end
end
