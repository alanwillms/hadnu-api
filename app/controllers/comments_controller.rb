class CommentsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

  def index
    authorize Comment
    if stale? etag: index_etag
      paginate json: comments.old_first, each_serializer: serializer
    end
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

  def update
    authorize comment
    expires_now

    if comment.update_attributes comment_params
      render json: comment
    else
      render json: comment.errors, status: :unprocessable_entity
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

  def comment
    @comment ||= policy_scope(discussion.comments).find(params[:id])
  end

  def comments
    scope = if params[:discussion_id]
      discussion.comments
    else
      user.comments.order(created_at: :desc)
    end

    policy_scope(scope).includes([:user, :discussion])
  end

  def serializer
    if params[:discussion_id]
      CommentSerializer
    else
      Comments::ShowSerializer
    end
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
