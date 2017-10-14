class DiscussionsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

  # @deprecated in favor of GraphQL
  def index
    authorize Discussion
    paginate json: discussions.recent_first.all if stale? etag: index_etag
  end

  # @deprecated in favor of GraphQL
  def show
    authorize discussion
    if stale? etag: show_etag
      discussion.hit!
      render json: discussion
    end
  end

  def create
    form = CreateDiscussionService.new(current_user, discussion_params)
    authorize form.discussion
    expires_now

    if form.save
      render json: form.discussion, status: :created, location: form.discussion
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize discussion
    expires_now
    form = UpdateDiscussionService.new(discussion, discussion_params)

    if form.save
      render json: form.discussion
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def index_etag
    [
      User.maximum(:updated_at).to_s,
      discussions.maximum(:updated_at).to_s,
      discussions.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def show_etag
    discussion.updated_at.to_s
  end

  def discussions
    scope = if params[:subject_id]
      policy_scope(Subject.find(params[:subject_id]).discussions)
    else
      policy_scope(Discussion)
    end
    scope.includes([:subject, :user, :last_user])
  end

  def discussion
    @discussion ||= policy_scope(Discussion).find(params[:id])
  end

  def discussion_params
    permitted = [:title, :subject_id, :comment]
    permitted.push(:closed) if current_user.admin?
    params.require(:discussion).permit(*permitted)
  end
end
