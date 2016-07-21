class UserConfirmationsController < ApplicationController
  def create
    skip_authorization
    expires_now
    token = user_confirmation_params[:token]
    user = token.to_s.empty? ? nil : User.find_by(confirmation_code: token)
    if user
      user.confirmation_code = nil
      user.email_confirmed = true

      if user.save
        render json: { login: user.login }, status: :created
        return
      end
    end

    render json: {}, status: :bad_request
  end

  private

  def user_confirmation_params
    params.require(:user_confirmation).permit(:token)
  end
end
