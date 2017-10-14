class SubjectsController < ApplicationController
  # @deprecated in favor of GraphQL
  def index
    authorize Subject
    paginate json: subjects.all if stale? etag: index_etag
  end

  # @deprecated in favor of GraphQL
  def show
    authorize subject
    render json: subject if stale? etag: show_etag
  end

  private

  def index_etag
    [
      subjects.maximum(:updated_at).to_s,
      subjects.count.to_s,
      request[:page].to_s
    ].join(',')
  end

  def show_etag
    subject.updated_at.to_s
  end

  def subjects
    Subject.order(:name)
  end

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
