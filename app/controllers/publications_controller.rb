class PublicationsController < ApplicationController
  def index
    paginate json: Publication.recent_first.all
  end
end
