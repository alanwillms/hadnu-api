class FeaturedPublicationsController < ApplicationController
  def index
    authorize Publication
    if stale? etag: index_etag
      render json: featured_publications.recent_first.all
    end
  end

  private

  def index_etag
    [
      featured_publications.maximum(:updated_at).to_s,
      featured_publications.count.to_s
    ].join(',')
  end

  def featured_publications
    policy_scope(Publication).featured
  end
end
