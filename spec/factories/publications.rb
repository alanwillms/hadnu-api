FactoryGirl.define do
  factory :publication do
    title { Faker::Book.title }
    blocked false
    published true
  end
end
