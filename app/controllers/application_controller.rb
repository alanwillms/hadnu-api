class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Knock::Authenticable
  include Pundit
  after_action :verify_authorized
end
