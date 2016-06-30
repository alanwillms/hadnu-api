class SubjectsController < ApplicationController
  before_action :set_subject, only: :show

  def index
    authorize Subject
    paginate json: Subject.order(:name).all
  end

  def show
    authorize @subject
    render json: @subject
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end
end
