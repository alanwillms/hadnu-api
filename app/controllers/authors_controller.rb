class AuthorsController < ApplicationController
  before_action :set_author, only: :show

  def index
    authorize Author
    render json: authors.all
  end

  def show
    authorize @author
    render json: @author
  end

  private

  def authors
    if params[:random].to_s == '1'
      scope.random_order
    else
      scope.order(:pen_name)
    end
  end

  def set_author
    @author = scope.find(params[:id])
  end

  def scope
    policy_scope(Author)
  end
end
