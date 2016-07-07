class UserTokenController < Knock::AuthTokenController
  etag { current_user&.id }
  include Pundit
  before_action :skip_authorization
end
