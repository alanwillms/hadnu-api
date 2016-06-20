FactoryGirl.define do
  factory :comment do
    discussion
    user
    comment 'My great comment'
  end
end
