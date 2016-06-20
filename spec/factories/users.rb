require 'digest/sha1'

FactoryGirl.define do
  factory :user do
    name 'John Doe'
    login 'john'
    email 'john@example.org'
    salt 'salt'
    encrypted_password { Digest::SHA1.hexdigest('password' + salt) }
    email_confirmed true
    blocked false
    registration_ip '127.0.0.1'
  end
end
