class PublicationsController < ApplicationController
  def index
    authorize Publication
    paginate json: publications.recent_first.all if stale? etag: index_etag
  end

  def show
    authorize publication
    if stale? etag: show_etag
      render json: publication, serializer: Publications::ShowSerializer
    end
  end

  private

  def index_etag
    [
      publications.maximum(:updated_at).to_s,
      publications.count.to_s,
      request[:page].to_s,
      params[:author_id].to_s,
      params[:category_id].to_s
    ].join(',')
  end

  def show_etag
    [
      publication.updated_at.to_s,
      publication.sections.count.to_s,
      publication.sections.maximum(:updated_at).to_s
    ].join(',')
  end

  def publications
    scope = unfiltered_publications
    policy_scope scope
  end

  def unfiltered_publications
    if category
      category.publications
    elsif author
      author.publications
    else
      Publication
    end
  end

  def author
    @author ||= Author.find(params[:author_id]) if params[:author_id]
  end

  def category
    @category ||= Category.find(params[:category_id]) if params[:category_id]
  end

  def publication
    @publication ||= Publication.find(params[:id])
  end
end
