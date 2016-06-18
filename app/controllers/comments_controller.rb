class CommentsController < ApplicationController
  before_action :set_discussion
  before_action :authenticate_user, only: [:create]

  def index
    paginate json: @discussion.comments.old_first
  end

  def create
    comment = @discussion.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      render json: comment, status: :created, location: @comment
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:discussion_id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :discussion_id)
  end
end
