FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    git             { "git@github.com:manuelmeurer/#{name.downcase.gsub(/\W+/, '-')}.git" }
    tags            { 10.times.map { random_tag } }
  end
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  git        :string(255)
#  links      :text             default([]), not null, is an Array
#  name       :string(255)
#  slug       :string(255)      not null
#  tags       :json
#  created_at :datetime
#  updated_at :datetime
#
