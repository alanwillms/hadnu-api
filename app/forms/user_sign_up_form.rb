class UserSignUpForm
  attr_reader :user

  def initialize(params)
    @user = User.new(params)
  end

  def save
    user.confirmation_code ||= SecureRandom.uuid
    return false unless user.save
    UserMailer.registration_confirmation(user).deliver_now
    true
  end

  def errors
    errors = ActiveModel::Errors.new(self)
    if user.errors
      user.errors.each do |attribute, error|
        attribute = :password if attribute == :encrypted_password
        errors.add(attribute, error)
      end
    end
    errors
  end
end
