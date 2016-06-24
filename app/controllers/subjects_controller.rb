class SubjectsController < ApplicationController
  before_action :set_subject, only: :show

  def index
    paginate json: Subject.order(:name).all
  end

  def show
    render json: @subject
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end
end
