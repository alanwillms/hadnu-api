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

  describe '#admin?' do
    it 'returns true if the user has a role named owner' do
      user = create(:user)
      create(:role_user, user: user, role_name: 'owner')
      expect(user.admin?).to be(true)
    end

    it 'returns false if the user has another kind of role' do
      user = create(:user)
      create(:role_user, user: user, role_name: 'editor')
      expect(user.admin?).to be(false)
    end

    it 'returns false if the user has no role' do
      expect(create(:user).admin?).to be(false)
    end
  end

  describe '#password=' do
    it 'generates a salt if the salt is nil' do
      user = build(:user, salt: nil)
      user.password = 'foo'
      expect(user.salt).not_to be_nil
    end

    it 'stores the encrypted_password' do
      user = build(:user, encrypted_password: nil)
      user.password = 'foo'
      expect(user.encrypted_password).not_to be_nil
    end
  end

  describe '#authenticate' do
    it 'returns true if the encrypted_password matches the value' do
      user = build(:user)
      user.password = 'pikachu'
      expect(user.authenticate('pikachu')).to be(true)
    end

    it 'returns false if the encrypted_password does not match the value' do
      user = build(:user)
      user.password = 'pikachu'
      expect(user.authenticate('meowth')).to be(false)
    end
  end

  describe '.from_token_request' do
    it 'finds record by login based on params[auth][login]' do
      user = create(:user)
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:params).and_return(
        'auth' => { 'login' => user.login }
      )
      expect(User.from_token_request(request)).to eq(user)
    end

    it 'returns nil if cannot find by params[auth][login]' do
      create(:user)
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:params).and_return(
        'auth' => { 'login' => 'invalid' }
      )
      expect(User.from_token_request(request)).to be_nil
    end

    it 'returns nil if there is no params[auth][login]' do
      create(:user)
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:params).and_return(
        'auth' => {}
      )
      expect(User.from_token_request(request)).to be_nil
    end

    it 'returns nil if there is no params[auth]' do
      create(:user)
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:params).and_return({})
      expect(User.from_token_request(request)).to be_nil
    end
  end

  describe '.from_token_payload' do
    it 'finds user by id with JWT payload[sub]' do
      user = create(:user)
      expect(User.from_token_payload('sub' => user.id)).to eq(user)
    end

    it 'returns nil with invalid JWT payload[sub]' do
      create(:user)
      expect(User.from_token_payload('sub' => 0)).to be_nil
    end

    it 'returns nil with invalid JWT payload' do
      create(:user)
      expect(User.from_token_payload({})).to be_nil
    end
  end

  describe '.from_facebook' do
    let(:profile) do
      {
        'id' => 42,
        'name' => 'Douglas Adams',
        'email' => 'douglas.adams@adams.com',
        'verified' => true
      }
    end

    let(:request) do
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:remote_ip).and_return('127.0.0.1')
      request
    end

    it 'finds user by facebook_id if it matches' do
      user = create(:user, facebook_id: profile['id'])
      expect(User.from_facebook(profile, request)).to eq(user)
    end

    it 'finds user by email if it matches' do
      user = create(:user, email: profile['email'])
      expect(User.from_facebook(profile, request)).to eq(user)
    end

    it 'creates a new user if email and facebook_id don\'t match' do
      expect(User.from_facebook(profile, request)).to be_a(User)
    end

    it 'creates user login based on the email address' do
      expect(User.from_facebook(profile, request).login).to eq('douglasadams')
    end

    it 'raises an exception if the user is not verified' do
      profile['verified'] = false
      expect { User.from_facebook(profile, request) }.to raise_error
    end
  end

  describe '.from_google' do
    let(:profile) do
      {
        'sub' => 42,
        'name' => 'Douglas Adams',
        'email' => 'douglas.adams@adams.com',
        'email_verified' => true
      }
    end

    let(:request) do
      request = instance_double(ActionDispatch::Request)
      allow(request).to receive(:remote_ip).and_return('127.0.0.1')
      request
    end

    it 'finds user by google_id if it matches' do
      user = create(:user, google_id: profile['sub'])
      expect(User.from_google(profile, request)).to eq(user)
    end

    it 'finds user by email if it matches' do
      user = create(:user, email: profile['email'])
      expect(User.from_google(profile, request)).to eq(user)
    end

    it 'creates a new user if email and google_id don\'t match' do
      expect(User.from_google(profile, request)).to be_a(User)
    end

    it 'creates user login based on the email address' do
      expect(User.from_google(profile, request).login).to eq('douglasadams')
    end

    it 'raises an exception if the user is not verified' do
      profile['email_verified'] = false
      expect { User.from_google(profile, request) }.to raise_error
    end
  end
end
