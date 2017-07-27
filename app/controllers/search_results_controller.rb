class SearchResultsController < ApplicationController
  def index
    expires_now
    authorize PgSearch::Document
    paginate json: search_results, each_serializer: SearchResultSerializer
  end

  private

  def search_results
    results = PgSearch.multisearch(search_params[:term]).with_pg_search_highlight.includes([:searchable])
    results = results.where(searchable_type: search_params[:type]) unless search_params[:type].to_s.empty?
    policy_scope(results)
  end

  def search_params
    params.require(:term)
    params.permit(:type)
    params
  end
end
