class PublicationsController < ApplicationController
  before_action :set_publication, only: :show

  def index
    paginate json: publications.recent_first.all
  end

  def show
    render json: @publication
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

  def set_publication
    @publication = Publication.find(params[:id])
  end
end
