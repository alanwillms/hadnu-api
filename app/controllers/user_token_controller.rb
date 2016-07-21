class UserTokenController < Knock::AuthTokenController
  include Pundit
  before_action :skip_authorization
  before_action :expires_now
end
