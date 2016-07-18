class UserRequestNewPasswordForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email

  validates :email, presence: true, email: true

  def validate
    if super
      return true if user
      errors.add(:email, I18n.t('activerecord.errors.messages.unused_email'))
    end
    false
  end

  def save
    return false unless validate
    user.password_recovery_code ||= SecureRandom.uuid
    return false unless user.save
    UserMailer.reset_password(user).deliver_now
    true
  end

  def user
    @user ||= User.find_by(email: email)
  end
end
