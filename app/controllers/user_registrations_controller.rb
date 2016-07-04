require 'recaptcha'

class UserRegistrationsController < ApplicationController
  include Recaptcha::Verify

  def create
    skip_authorization
    data = user_registration_params
    data[:registration_ip] = request.remote_ip
    model = UserSignUpForm.new(data)

    if verify_recaptcha(model: model.user, attribute: :captcha) && model.save
      render json: model.user, status: :created
    else
      render json: model.errors, status: :unprocessable_entity
    end
  end

  private

  def user_registration_params
    params.require(:user_registration).permit(:captcha, :name, :login, :password, :email)
  end
end
