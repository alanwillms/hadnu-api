class SectionsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

  def show
    authorize section
    if stale? etag: show_etag
      render json: section, serializer: Sections::ShowSerializer
    end
  end

  def create
    section = Section.new(section_params)
    section.publication = publication
    section.user = current_user

    authorize section
    expires_now

    if section.save
      render json: section, status: :created
    else
      render json: section.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize section
    section.user = current_user

    expires_now

    if section.update section_params
      render json: section
    else
      render json: section.errors, status: :unprocessable_entity
    end
  end

  private

  def show_etag
    [
      section.updated_at.to_s,
      publication.updated_at.to_s,
      publication.sections.count.to_s,
      publication.sections.maximum(:updated_at).to_s
    ].join(',')
  end

  def publication
    @publication ||= policy_scope(Publication).find(params[:publication_id])
  end

  def section
    @section ||= policy_scope(publication.sections).find(params[:id])
  end

  def section_params
    params.require(:section).permit(
      :title, :source, :seo_description, :text,
      :parent_id, :position
    )
  end
end
