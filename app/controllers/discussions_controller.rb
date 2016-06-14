class DiscussionsController < ApplicationController
  def index
    @discussions = Discussion.all
    render json: @discussions
  end
end
