class PublicationsController < ApplicationController
  def index
    paginate json: publications.recent_first.all
  end

  private

  def publications
    if params[:category_id]
      Category.find(params[:category_id]).publications
    elsif params[:author_id]
      Author.find(params[:author_id]).publications
    else
      Publication
    end
  end
end
