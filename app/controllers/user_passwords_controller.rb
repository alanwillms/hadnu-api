class UserPasswordsController < ApplicationController
  include Recaptcha::Verify
  before_action :skip_authorization

  def create
    form = UserRequestNewPasswordForm.new(new_params)
    valid = form.validate && verify_recaptcha(model: form, attribute: :captcha)
    if valid && form.save
      render json: {}, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  def update
    form = UserResetPasswordForm.new(update_params)
    if form.save
      render json: form.user
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def new_params
    params.require(:user_password).permit(:email)
  end

  def update_params
    params
      .require(:user_password)
      .permit(:password, :password_confirmation, :token)
  end
end
