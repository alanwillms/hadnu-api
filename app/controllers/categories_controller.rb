class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    paginate json: Category.order(:name).all
  end

  def show
    render json: @category
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
