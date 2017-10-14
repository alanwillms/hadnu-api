class PseudonymsController < ApplicationController
  # @deprecated in favor of GraphQL
  def index
    authorize Pseudonym
    render json: pseudonyms.all if stale? etag: index_etag
  end

  private

  def index_etag
    pseudonyms.maximum(:updated_at).to_s + ',' + pseudonyms.count.to_s
  end

  def scope
    policy_scope(Pseudonym)
  end

  def pseudonyms
    scope.order(:name)
  end
end
