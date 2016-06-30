class AuthorsController < ApplicationController
  before_action :set_author, only: :show

  def index
    authorize Author
    if params[:all]
      render json: authors
    else
      paginate json: authors
    end
  end

  def show
    authorize @author
    render json: @author
  end

  private

  def authors
    if params[:random].to_s === '1'
      policy_scope(Author).random_order.all
    else
      policy_scope(Author).order(:pen_name).all
    end
  end

  def set_author
    @author = policy_scope(Author).find(params[:id])
  end
end
