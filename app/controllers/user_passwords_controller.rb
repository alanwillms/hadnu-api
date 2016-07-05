class UserPasswordsController < ApplicationController
  include Recaptcha::Verify

  def create
    skip_authorization
    form_params = params.require(:user_password).permit(:email)
    form = UserRequestNewPasswordForm.new(form_params)
    if verify_recaptcha(model: form, attribute: :captcha) && form.save
      render json: {}, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  def update
    skip_authorization
    form_params = params.require(:user_password).permit(:password, :password_confirmation, :token)
    form = UserResetPasswordForm.new(form_params)
    if form.save
      render json: form.user
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end
end
