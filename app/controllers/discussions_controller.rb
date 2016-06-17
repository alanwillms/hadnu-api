class DiscussionsController < ApplicationController
  # before_action :authenticate_user
  before_action :set_discussion, only: [:show]

  def index
    paginate json: Discussion.recent_first.all
  end

  def show
    render json: @discussion
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end
end
