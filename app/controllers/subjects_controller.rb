class SubjectsController < ApplicationController
  def index
    paginate json: Subject.order(:name).all
  end
end
