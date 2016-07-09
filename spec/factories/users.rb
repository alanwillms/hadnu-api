require 'digest/sha1'
require 'faker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    login { Faker::Internet.user_name(nil, []) }
    email { Faker::Internet.safe_email }
    salt 'salt'
    encrypted_password { Digest::SHA1.hexdigest('password' + salt) }
    email_confirmed true
    blocked false
    registration_ip { Faker::Internet.ip_v4_address }
  end
end
