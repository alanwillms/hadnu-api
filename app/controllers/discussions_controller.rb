class DiscussionsController < ApplicationController
  def index
    paginate json: Discussion.all
  end
end
