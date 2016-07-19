require 'digest/sha1'

class User < ApplicationRecord
  LOGIN_FORMAT = /\A[a-z]{1}[a-z0-9\_]*\z/

  has_many :authors
  has_many :pseudonyms
  has_many :discussions
  has_many :comments
  has_many :publications
  has_many :sections
  has_many :roles, class_name: 'RoleUser'

  validates :name, presence: true, length: { maximum: 255 }
  validates :salt, presence: true, length: { maximum: 36 }
  validates :encrypted_password, presence: true, length: { maximum: 255 }
  validates :login,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: LOGIN_FORMAT }
  validates :email,
            presence: true,
            email: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :google_id,
            length: { maximum: 255 },
            uniqueness: { allow_nil: true }
  validates :facebook_id,
            length: { maximum: 255 },
            uniqueness: { allow_nil: true }
  validates :password_recovery_code,
            length: { maximum: 36 },
            uniqueness: { allow_nil: true }
  validates :confirmation_code,
            length: { maximum: 36 },
            uniqueness: { allow_nil: true }
  validates :registration_ip,
            presence: true,
            ipaddr: { ipv4: true, ipv6: true },
            length: { maximum: 255 }
  validates :last_login_ip,
            ipaddr: { ipv4: true, ipv6: true, allow_nil: true },
            length: { maximum: 255 }
  validates :last_login_at, date: { allow_nil: true }

  def admin?
    roles.any? { |role| role.role_name == 'owner' }
  end

  def password=(value)
    generate_salt unless salt
    self.encrypted_password = value ? Digest::SHA1.hexdigest(value + salt) : nil
  end

  def authenticate(password)
    encrypted_password == Digest::SHA1.hexdigest(password + salt)
  end

  def self.from_token_request(request)
    login = request.params['auth'] && request.params['auth']['login']
    active.find_by login: login
  end

  def self.from_token_payload(payload)
    logger.fatal payload.inspect
    active.find_by id: (payload['sub'] || payload[:sub])
  end

  def self.active
    where(blocked: false, email_confirmed: true)
  end

  def self.from_facebook(profile, request)
    where(facebook_id: profile['id']).or(where(email: profile['email'])).first_or_initialize.tap do |user|
      user.facebook_id = profile['id']
      user.name = profile['name']
      user.login = profile['email'].split('@').first.downcase.gsub(/[^a-z0-9\_]/, '')
      user.email = profile['email']
      if user.new_record?
        user.password = SecureRandom.uuid
        user.registration_ip = request.remote_ip
      end
      user.save!
    end
  end

  def self.from_google(profile, request)
    where(google_id: profile['sub']).or(where(email: profile['email'])).first_or_initialize.tap do |user|
      user.google_id = profile['sub']
      user.name = profile['name']
      user.login = profile['email'].split('@').first.downcase.gsub(/[^a-z0-9\_]/, '')
      user.email = profile['email']
      if user.new_record?
        user.password = SecureRandom.uuid
        user.registration_ip = request.remote_ip
      end
      user.save!
    end
  end

  private

  def generate_salt
    self.salt = SecureRandom.uuid
  end
end
