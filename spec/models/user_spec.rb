require 'rails_helper'

describe User do
  context 'validations' do
    before { create(:user) }

    it { should have_many(:publications) }
    it { should have_many(:sections) }
    it { should have_many(:pseudonyms) }
    it { should have_many(:authors) }
    it { should have_many(:discussions) }
    it { should have_many(:comments) }
    it { should have_many(:roles) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:encrypted_password) }
    it { should validate_presence_of(:registration_ip) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:login).is_at_most(255) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:encrypted_password).is_at_most(255) }
    it { should validate_length_of(:salt).is_at_most(36) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:last_login_ip).is_at_most(255) }
    it { should validate_length_of(:confirmation_code).is_at_most(36) }
    it { should validate_length_of(:password_recovery_code).is_at_most(36) }
    it { should validate_length_of(:registration_ip).is_at_most(255) }
    it { should validate_length_of(:google_id).is_at_most(255) }
    it { should validate_length_of(:facebook_id).is_at_most(255) }
    it { should validate_uniqueness_of(:login).case_insensitive }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:confirmation_code) }
    it { should validate_uniqueness_of(:password_recovery_code) }
    it { should validate_uniqueness_of(:google_id) }
    it { should validate_uniqueness_of(:facebook_id) }
    it { should validate_inclusion_of(:email_confirmed).in_array([true, false]) }
    it { should validate_inclusion_of(:blocked).in_array([true, false]) }
    it { should allow_value('1989-07-03 22:50:00').for(:last_login_at) }
    it { should_not allow_value('foo').for(:last_login_at) }
    it { should allow_value('127.0.0.1').for(:last_login_ip) }
    it { should allow_value('127.0.0.1').for(:registration_ip) }
    it { should allow_value('FE80::0202:B3FF:FE1E:8329').for(:last_login_ip) }
    it { should allow_value('FE80::0202:B3FF:FE1E:8329').for(:registration_ip) }
    it { should_not allow_value('foo').for(:last_login_ip) }
    it { should_not allow_value('foo').for(:registration_ip) }
    it { should allow_value('john@doe.com').for(:email) }
    it { should_not allow_value('foobar').for(:email) }
    it { should allow_value('john_doe').for(:login) }
    it { should allow_value('john93').for(:login) }
    it { should_not allow_value('John Doe').for(:login) }
    it { should_not allow_value('John').for(:login) }
    it { should_not allow_value('93john').for(:login) }
  end
end
