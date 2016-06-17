class CommentsController < ApplicationController
  before_action :set_discussion

  def index
    paginate json: @discussion.comments.recent_first
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:discussion_id])
  end
end
