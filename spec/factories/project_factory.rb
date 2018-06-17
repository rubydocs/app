FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    git             { "git@github.com:krautcomputing/#{name.downcase.gsub(/\W+/, '-')}.git" }
    tags            { 10.times.map { random_tag } }
  end
end
