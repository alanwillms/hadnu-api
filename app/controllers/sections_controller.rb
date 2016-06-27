class SectionsController < ApplicationController
  before_action :set_publication, only: :show
  before_action :set_section, only: :show

  def show
    render json: @section
  end

  private

  def set_publication
    @publication = Publication.find(params[:publication_id])
  end

  def set_section
    @section = Section.find(params[:id])
  end
end
