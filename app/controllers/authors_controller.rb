class AuthorsController < ApplicationController
  before_action :set_author, only: :show

  def index
    paginate json: Author.order(:pen_name).all
  end

  def show
    render json: @author
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end
end
