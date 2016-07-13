class UserRequestNewPasswordForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email

  validates :email, presence: true, email: true

  def save
    return false unless validate && user
    user.password_recovery_code ||= SecureRandom.uuid
    return false unless user.save
    UserMailer.reset_password(user).deliver_now
    true
  end

  def user
    @user ||= User.find_by(email: email)
  end
end
