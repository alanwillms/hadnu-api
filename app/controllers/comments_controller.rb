class CommentsController < ApplicationController
  before_action :set_discussion
  before_action :authenticate_user, only: [:create]

  def index
    authorize Comment
    paginate json: policy_scope(@discussion.comments).old_first
  end

  def create
    form = CommentForm.new(@discussion, current_user, comment_params)
    authorize form.comment

    if form.save
      render json: form.comment, status: :created
    else
      render json: form.errors, status: :unprocessable_entity
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
