class AuthorsController < ApplicationController
  def index
    authorize Author
    render json: authors.all if stale? etag: index_etag
  end

  def show
    authorize author
    render json: author if stale? etag: show_etag
  end

  private

  def index_etag
    authors.maximum(:updated_at).to_s + ',' + authors.count.to_s
  end

  def show_etag
    [
      author.updated_at.to_s,
      policy_scope(author.publications).count.to_s,
      policy_scope(author.publications).maximum(:updated_at)
    ].join(',')
  end

  def scope
    policy_scope(Author)
  end

  def authors
    scope.order(:pen_name)
  end

  def author
    @author ||= scope.find(params[:id])
  end
end
