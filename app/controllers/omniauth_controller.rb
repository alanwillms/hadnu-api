class OmniauthController < ApplicationController
  def create
    graph = Koala::Facebook::API.new(params['accessToken'], ENV['HADNU_FACEBOOK_SECRET'])
    profile = graph.get_object("me", {fields: "id,name,email"}, api_version: "v2.6")
    user = User.from_facebook(profile)
    auth_token = Knock::AuthToken.new payload: { sub: user.id }
    render json: auth_token, status: :created
  end
end
