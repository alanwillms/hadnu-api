require 'digest/sha1'
require 'faker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:login) { |n| Faker::Internet.user_name(nil, []) + n.to_s }
    sequence(:email) { |n| "#{n}#{Faker::Internet.safe_email}" }
    salt 'salt'
    encrypted_password { Digest::SHA1.hexdigest('password' + salt.to_s) }
    email_confirmed true
    blocked false
    registration_ip { Faker::Internet.ip_v4_address }

    factory :admin_user do
      after(:create) do |user, _|
        create(:role_user, user: user, role_name: 'owner')
      end
    end
  end
end
