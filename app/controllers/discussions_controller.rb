class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show]
  before_action :authenticate_user, only: [:create]

  def index
    authorize Discussion
    paginate json: discussions.recent_first.all
  end

  def show
    authorize @discussion
    render json: @discussion
  end

  def create
    form = DiscussionForm.new(current_user, new_discussion_params)
    authorize form.discussion

    if form.save
      render json: form.discussion, status: :created, location: form.discussion
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def discussions
    if params[:subject_id]
      policy_scope(Subject.find(params[:subject_id]).discussions)
    else
      policy_scope(Discussion)
    end
  end

  def set_discussion
    @discussion = policy_scope(Discussion).find(params[:id])
  end

  def new_discussion_params
    params.require(:discussion).permit(:title, :comment, :subject_id)
  end
end
