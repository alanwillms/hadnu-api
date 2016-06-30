class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    authorize Category
    paginate json: policy_scope(Category).order(:name).all
  end

  def show
    authorize @category
    render json: @category
  end

  private

  def set_category
    @category = policy_scope(Category).find(params[:id])
  end
end
