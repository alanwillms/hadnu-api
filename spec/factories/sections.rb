FactoryGirl.define do
  factory :section do
    title { Faker::Book.title }
    publication
  end
end
