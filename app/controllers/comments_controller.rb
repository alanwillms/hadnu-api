class CommentsController < ApplicationController
  before_action :authenticate_user, only: :create

  def index
    authorize Comment
    paginate json: comments.old_first if stale? etag: index_etag
  end

  def create
    form = CommentForm.new(discussion, current_user, comment_params)
    authorize form.comment
    expires_now

    if form.save
      render json: form.comment, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def index_etag
    [
      User.maximum(:updated_at).to_s,
      comments.maximum(:updated_at).to_s,
      comments.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def discussion
    @discussion ||= Discussion.find(params[:discussion_id])
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def comments
    scope = if params[:discussion_id]
      discussion.comments
    else
      user.comments.order(created_at: :desc)
    end

    policy_scope(scope).includes([:user])
  end

  def comment_params
    params.require(:comment).permit(:comment, :discussion_id)
  end
end
