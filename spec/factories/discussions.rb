FactoryGirl.define do
  factory :discussion do
    title 'Who was born first?'
    hits 0
    comments_counter 0
    closed false
    user
    last_user { user }
    subject
    commented_at { created_at }
  end
end
