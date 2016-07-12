FactoryGirl.define do
  factory :publication do
    user
    title { Faker::Book.title }
    blocked false
    published true
  end
end
