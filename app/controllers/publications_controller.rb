class PublicationsController < ApplicationController
  before_action :set_publication, only: :show

  def index
    authorize Publication
    paginate json: publications.recent_first.all
  end

  def show
    authorize @publication
    render json: @publication, serializer: Publications::ShowSerializer
  end

  private

  def publications
    scope = if params[:category_id]
      Category.find(params[:category_id]).publications
    elsif params[:author_id]
      Author.find(params[:author_id]).publications
    else
      Publication
    end
    policy_scope scope
  end

  def set_publication
    @publication = Publication.find(params[:id])
  end
end
