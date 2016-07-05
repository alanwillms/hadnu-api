class UserPasswordsController < ApplicationController
  include Recaptcha::Verify

  def create
    skip_authorization
    form = UserPasswordForm.new(new_user_password_params)
    if verify_recaptcha(model: form, attribute: :captcha) && form.save
      render json: form.user, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def new_user_password_params
    params.require(:user_password).permit(:email)
  end
end
