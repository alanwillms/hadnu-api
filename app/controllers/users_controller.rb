class UsersController < ApplicationController
  before_action :authenticate_user

  def show
    authorize user
    render json: user if stale? etag: show_etag
  end

  private

  def show_etag
    user.updated_at.to_s
  end

  def user
    @user ||= User.find(params[:id])
  end
end
