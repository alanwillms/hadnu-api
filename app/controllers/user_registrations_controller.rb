require 'recaptcha'

class UserRegistrationsController < ApplicationController
  include Recaptcha::Verify

  def create
    skip_authorization
    expires_now
    form = UserSignUpForm.new(user_registration_params)
    valid = form.validate && verify_recaptcha(model: form, attribute: :captcha)

    if valid && form.save
      render json: form.user, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def user_registration_params
    user_data = params.require(:user_registration)
                      .permit(:captcha, :name, :login, :password, :email)
    user_data[:registration_ip] = request.remote_ip
    user_data
  end
end
