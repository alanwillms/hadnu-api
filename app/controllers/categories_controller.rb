class CategoriesController < ApplicationController
  def index
    authorize Category
    paginate json: scope.order(:name).all if stale? etag: index_etag
  end

  def show
    authorize category
    render json: category if stale? etag: show_etag
  end

  private

  def index_etag
    [
      scope.maximum(:updated_at).to_s,
      scope.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def show_etag
    [
      category.updated_at.to_s,
      policy_scope(category.publications).count.to_s,
      policy_scope(category.publications).maximum(:updated_at)
    ].join(',')
  end

  def category
    @category ||= scope.find(params[:id])
  end

  def scope
    policy_scope(Category)
  end
end
