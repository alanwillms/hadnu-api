class FeaturedPublicationsController < ApplicationController
  def index
    authorize Publication
    render json: policy_scope(Publication).featured.recent_first.all
  end
end
