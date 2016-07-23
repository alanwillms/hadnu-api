class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Knock::Authenticable
  include Pundit
  after_action :verify_authorized
  serialization_scope :current_user

  # For some reason, Knock::Authenticable method sometimes fail to set the user
  def current_user
    @current_user ||= Knock::AuthToken.new(token: token).entity_for(User)
  end

  private

  # Only take token from headers, never from URL (like Knock does)
  def token
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end
end
