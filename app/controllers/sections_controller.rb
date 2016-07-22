class SectionsController < ApplicationController
  def show
    authorize section
    if stale? etag: show_etag
      render json: section, serializer: Sections::ShowSerializer
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
end
