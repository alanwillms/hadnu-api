FactoryGirl.define do
  factory :publication do
    title { Faker::Book.title }
  end
end