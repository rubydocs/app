FactoryGirl.define do
  factory :doc do
    association :project
    tag         { project.tags.sample }
  end
end
