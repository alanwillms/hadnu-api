FactoryGirl.define do
  factory :discussion do
    title { Faker::Hipster.sentence(3) }
    hits 0
    comments_counter 0
    closed false
    user
    last_user { user }
    subject
    commented_at { Time.now }

    factory :discussion_with_comment do
      after(:create) do |discussion, _|
        create(:comment, discussion: discussion)
      end
    end
  end
end
