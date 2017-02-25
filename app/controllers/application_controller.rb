class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Knock::Authenticable
  include Pundit
  after_action :verify_authorized
  serialization_scope :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_graceful_not_found
  rescue_from Pundit::NotDefinedError, with: :render_graceful_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_graceful_not_authorized

  # For some reason, Knock::Authenticable method sometimes fail to set the user
  def current_user
    return nil unless token
    @current_user ||= Knock::AuthToken.new(token: token).entity_for(User)
  end

  private

  # Only take token from headers, never from URL (like Knock does)
  def token
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end

  def render_graceful_not_found
    render json: { error: I18n.t('actionpack.errors.record_not_found') }, status: :not_found
  end

  def render_graceful_not_authorized
    render json: { error: I18n.t('actionpack.errors.unauthorized') }, status: :unauthorized
  end
end
