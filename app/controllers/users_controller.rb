class UsersController < ApplicationController
  before_action :authenticate_user

  def show
    authorize user
    render json: user if stale? etag: show_etag
  end

  def update
    authorize user
    expires_now

    if user.update user_params
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def show_etag
    [
        user.photo.url,
        user.updated_at.to_s,
        user.comments.count,
        user.discussions.count,
        Discussion.includes('comments').where(comments: { user_id: user.id }).count
    ].join('-')
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      photo_base64: [:base64, :name]
    )
  end
end
