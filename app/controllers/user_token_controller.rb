class UserTokenController < Knock::AuthTokenController
  include Pundit
  before_action :skip_authorization
end
