FactoryGirl.define do
  factory :pseudonym do
    name { Faker::Name.name }
    author
    user
  end
end
