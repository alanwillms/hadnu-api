class AuthorsController < ApplicationController
  def index
    paginate json: Author.order(:pen_name).all
  end
end
