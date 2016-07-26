class OmniauthSessionsController < ApplicationController
  def create
    skip_authorization
    expires_now
    form = OmniauthSignInForm.new(
      provider: params['provider'],
      token: params['accessToken']
    )
    user = form.user
    if form.errors.any?
      render json: form.errors, status: :forbidden
    elsif user.new_record?
      render json: form.user_data, status: :unprocessable_entity
    else
      render json: user_token(user), status: :created
    end
  end

  private

  def user_token(user)
    Knock::AuthToken.new payload: { sub: user.id }
  end
end
