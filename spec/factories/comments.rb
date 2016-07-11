FactoryGirl.define do
  factory :comment do
    discussion
    user
    comment { Faker::Hipster.sentence }
  end
end
