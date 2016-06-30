class SectionsController < ApplicationController
  before_action :set_publication, only: :show
  before_action :set_section, only: :show

  def show
    authorize @section
    render json: @section, serializer: Sections::ShowSerializer
  end

  private

  def set_publication
    @publication = policy_scope(Publication).find(params[:publication_id])
  end

  def set_section
    @section = policy_scope(Section).find(params[:id])
  end
end
