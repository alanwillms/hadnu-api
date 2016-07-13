# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def new_user
    user = User.where('confirmation_code is not null').last
    UserMailer.registration_confirmation(user)
  end
end
