class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    authorize Category
    paginate json: scope.order(:name).all
  end

  def show
    authorize @category
    render json: @category
  end

  private

  def set_category
    @category = scope.find(params[:id])
  end

  def scope
    policy_scope(Category)
  end
end
