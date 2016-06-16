class DiscussionsController < ApplicationController
  # before_action :authenticate_user

  def index
    paginate json: Discussion.recent_first.all
  end
end
