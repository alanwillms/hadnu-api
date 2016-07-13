# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def registration_confirmation
    user = User.where('confirmation_code is not null').last
    UserMailer.registration_confirmation(user)
  end

  def reset_password
    user = User.where('password_recovery_code is not null').last
    UserMailer.reset_password(user)
  end
end
