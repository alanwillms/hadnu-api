class UserPasswordForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email

  validates :email, presence: true

  def save
    validate
  end

  def user
    @user ||= User.find_by(email: email)
  end
end
