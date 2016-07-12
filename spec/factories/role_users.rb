FactoryGirl.define do
  factory :role_user do
    user
    role_name { %w(editor owner).sample }
  end
end
