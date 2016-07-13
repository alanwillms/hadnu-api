class UserResetPasswordForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :password, :password_confirmation, :token

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  validates :token, presence: true

  def save
    unless user
      errors.add(:token, 'Token expired or invalid')
      return false
    end
    return false unless validate
    user.password = password
    user.password_recovery_code = nil
    user.save
  end

  def user
    return nil if token.to_s.empty?
    @user ||= User.find_by(password_recovery_code: token)
  end

  def self.i18n_scope
    :activerecord
  end
end
