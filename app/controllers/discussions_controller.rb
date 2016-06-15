class DiscussionsController < ApplicationController
  def index
    paginate json: Discussion.recent_first.all
  end
end
