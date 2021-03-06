require 'digest/sha1'

class User < ApplicationRecord
  LOGIN_FORMAT = /\A[a-z]{1}[a-z0-9\_ ]*[a-z0-9]{1}\z/

  has_many :authors
  has_many :pseudonyms
  has_many :discussions
  has_many :comments
  has_many :publications
  has_many :sections
  has_many :roles, class_name: 'RoleUser'
  has_attached_file :photo,
                    styles: { mini: '18x18#', thumb: '70x70#', profile: '200x200#' },
                    default_url: '/images/missing/user/:style.jpg',
                    convert_options: {
                      mini: '-quality 85 -strip',
                      thumb: '-quality 85 -strip',
                      profile: '-quality 85 -strip'
                    }

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
  validates_attachment_content_type :photo, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :photo, less_than: 2.megabytes
  validates :comments_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :discussions_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :downcase_fields

  def admin?
    roles.any? { |role| role.role_name == 'owner' }
  end

  def slug
    ActiveSupport::Inflector.parameterize("#{id}-#{login}")
  end

  def password=(value)
    generate_salt unless salt
    self.encrypted_password = value ? Digest::SHA1.hexdigest(value + salt) : nil
  end

  def authenticate(password)
    encrypted_password == Digest::SHA1.hexdigest(password + salt)
  end

  def to_token_payload
    { sub: id, acl: roles.first&.role_name }
  end

  def self.from_token_request(request)
    return nil unless request.params['auth'] && request.params['auth']['login']
    find_by_login_or_email request.params['auth']['login'].downcase
  end

  def self.find_by_login_or_email(credential)
    active.where(['login = ? OR email = ?', credential, credential]).first
  end

  def self.from_token_payload(payload)
    active.find_by id: (payload['sub'] || payload[:sub])
  end

  def self.active
    where(blocked: false, email_confirmed: true)
  end

  def photo_base64=(data)
    set_file_from_base64(:photo, data)
  end

  private

  def generate_salt
    self.salt = SecureRandom.uuid
  end

  def downcase_fields
    login.downcase!
    email.downcase!
  end
end
