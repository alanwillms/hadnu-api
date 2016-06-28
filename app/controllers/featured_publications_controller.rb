class FeaturedPublicationsController < ApplicationController
  def index
    render json: Publication.featured.recent_first.all
  end
end
