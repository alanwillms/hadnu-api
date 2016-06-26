class CategoriesController < ApplicationController
  def index
    paginate json: Category.order(:name).all
  end
end
