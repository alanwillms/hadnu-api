class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    @name = user.name
    @confirmation_url = [
      ENV['HADNU_EMAIL_CONFIRMATION_URL'],
      user.confirmation_code
    ].join
    mail to: user.email, subject: I18n.t('email.confirm_email.subject')
  end

  def reset_password(user)
    @name = user.name
    @reset_password_url = [
      ENV['HADNU_PASSWORD_RESET_URL'],
      user.password_recovery_code
    ].join
    mail to: user.email, subject: I18n.t('email.reset_password.subject')
  end
end
