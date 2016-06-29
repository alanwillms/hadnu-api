class UserSignUpForm
  attr_reader :user

  def initialize(params)
    @user = User.new(params)
  end

  def save
    user.save
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
