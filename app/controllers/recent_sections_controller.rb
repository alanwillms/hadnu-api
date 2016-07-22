class RecentSectionsController < ApplicationController
  def index
    authorize Section
    if stale? etag: index_etag
      paginate json: recent_sections, each_serializer: RecentSectionSerializer
    end
  end

  private

  def index_etag
    [
      recent_sections.maximum(:updated_at).to_s,
      recent_sections.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def recent_sections
    policy_scope(Section).recent
  end
end
