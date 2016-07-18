class UserSignUpForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name, :email, :login, :password, :registration_ip

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :login, presence: true
  validates :password, presence: true
  validates :registration_ip, presence: true

  def user
    @user ||= User.new(
      name: name,
      email: email,
      login: login,
      password: password,
      registration_ip: registration_ip
    )
  end

  def validate
    super & user.validate
  end

  def save
    return false unless validate
    user.confirmation_code ||= SecureRandom.uuid
    return false unless user.save
    UserMailer.registration_confirmation(user).deliver_now
    true
  end

  def errors
    errors = super
    return errors unless user.errors
    user.errors.each do |attribute, error|
      attribute = :password if attribute == :encrypted_password
      next if !respond_to?(attribute) || errors.added?(attribute, error)
      errors.add(attribute, error)
    end
    errors
  end
end
