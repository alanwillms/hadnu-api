class DiscussionsController < ApplicationController
  before_action :authenticate_user, only: :create

  def index
    authorize Discussion
    paginate json: discussions.recent_first.all if stale? etag: index_etag
  end

  def show
    authorize discussion
    if stale? etag: show_etag
      Discussion.where(id: discussion.id).update_all('hits = hits + 1')
      render json: discussion
    end
  end

  def create
    form = DiscussionForm.new(current_user, new_discussion_params)
    authorize form.discussion
    expires_now

    if form.save
      render json: form.discussion, status: :created, location: form.discussion
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def index_etag
    [
      discussions.maximum(:updated_at).to_s,
      discussions.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def show_etag
    discussion.updated_at.to_s
  end

  def discussions
    if params[:subject_id]
      policy_scope(Subject.find(params[:subject_id]).discussions)
    else
      policy_scope(Discussion)
    end
  end

  def discussion
    @discussion ||= policy_scope(Discussion).find(params[:id])
  end

  def new_discussion_params
    params.require(:discussion).permit(:title, :comment, :subject_id)
  end
end
