class UserTokenController < Knock::AuthTokenController
  skip_authorization
end
