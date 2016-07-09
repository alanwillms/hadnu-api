require 'digest/sha1'

class User < ApplicationRecord
  has_many :discussions
  has_many :roles, class_name: 'RoleUser'

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true

  def admin?
    roles.any? { |role| role.role_name == 'owner' }
  end

  def password=(value)
    generate_salt unless self.salt
    self.encrypted_password = value ? Digest::SHA1.hexdigest(value + self.salt) : nil
  end

  def authenticate(password)
    self.encrypted_password == Digest::SHA1.hexdigest(password + self.salt)
  end

  def self.from_token_request(request)
    login = request.params["auth"] && request.params["auth"]["login"]
    active.find_by login: login
  end

  def self.from_token_payload(payload)
    active.find_by id: payload['sub']
  end

  def self.active
    where(blocked: false, email_confirmed: true)
  end

  def self.from_facebook(profile)
    where(facebook_id: profile['id']).or(where(email: profile['email'])).first_or_initialize.tap do |user|
      user.facebook_id = profile['id']
      user.name = profile['name']
      user.login = profile['name']
      user.email = profile['email']
      user.save!
    end
  end

  def self.from_google(profile)
    where(google_id: profile['sub']).or(where(email: profile['email'])).first_or_initialize.tap do |user|
      user.google_id = profile['sub']
      user.name = profile['name']
      user.login = profile['name']
      user.email = profile['email']
      user.save!
    end
  end

  private

  def generate_salt
    self.salt = SecureRandom.uuid
  end
end
