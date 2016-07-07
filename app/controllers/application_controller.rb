class ApplicationController < ActionController::API
  etag { current_user&.id }

  include ActionController::Serialization
  include Knock::Authenticable
  include Pundit
  after_action :verify_authorized
end
