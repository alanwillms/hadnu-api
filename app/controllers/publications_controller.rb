class PublicationsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

  def index
    authorize Publication
    paginate json: publications.recent_first.all if stale? etag: index_etag
  end

  def show
    authorize publication
    if stale? etag: show_etag
      publication.hit!
      render json: publication, serializer: Publications::ShowSerializer
    end
  end

  def create
    publication = Publication.new publication_params
    publication.user = current_user
    authorize publication
    expires_now

    if publication.save
      render json: publication, status: :created
    else
      render json: publication.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize publication
    expires_now

    if publication.update publication_params
      render json: publication
    else
      render json: publication.errors, status: :unprocessable_entity
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
      publication.sections.maximum(:updated_at).to_s,
      publication.categories.count.to_s,
      publication.categories.sum(:id).to_s,
      publication.pseudonyms.count.to_s,
      publication.pseudonyms.sum(:id).to_s
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
    @publication ||= Publication.where(id: params[:id]).includes({
      publications_categories: [:category],
      categories: []
    }).first
  end

  def publication_params
    params.require(:publication).permit(
      :title, :original_title, :description, :copyright_notice,
      :featured, :blocked, :published, :signed_reader_only,
      category_ids: [],
      pseudonym_ids: [],
      banner_base64: [:base64, :name],
      pdf_base64: [:base64, :name]
    )
  end
end
