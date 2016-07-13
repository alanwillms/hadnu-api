FactoryGirl.define do
  factory :publication do
    user
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    blocked false
    published true
  end
end
