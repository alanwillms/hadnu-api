class AuthorsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

  def index
    authorize Author
    render json: authors.all if stale? etag: index_etag
  end

  def show
    authorize author
    if stale? etag: show_etag
      render json: author, serializer: Authors::ShowSerializer
    end
  end

  def create
    author = Author.new author_params
    author.user = current_user
    authorize author
    expires_now

    if author.save
      render json: author, status: :created
    else
      render json: author.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize author
    expires_now

    if author.update author_params
      render json: author
    else
      render json: author.errors, status: :unprocessable_entity
    end
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

  def author_params
    params.require(:author).permit(
      :pen_name, :real_name, :description, :born_on, :passed_away_on,
      photo_base64: [:base64, :name]
    )
  end
end
