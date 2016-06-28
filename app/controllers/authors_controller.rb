class AuthorsController < ApplicationController
  before_action :set_author, only: :show

  def index
    if params[:all]
      render json: authors
    else
      paginate json: authors
    end
  end

  def show
    render json: @author
  end

  private

  def authors
    if params[:random].to_s === '1'
      Author.random_order.all
    else
      Author.order(:pen_name).all
    end
  end

  def set_author
    @author = Author.find(params[:id])
  end
end
