class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show]
  before_action :authenticate_user, only: [:create]

  def index
    paginate json: Discussion.recent_first.all
  end

  def show
    render json: @discussion
  end

  def create
    form = DiscussionForm.new(current_user, new_discussion_params)

    if form.save
      render json: form.discussion, status: :created, location: form.discussion
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def new_discussion_params
    params.require(:discussion).permit(:title, :comment, :subject_id)
  end
end
