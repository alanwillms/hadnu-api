require 'net/http'

class OmniauthController < ApplicationController
  def create
    user = nil

    if params[:provider] == 'facebook'
      graph = Koala::Facebook::API.new(params['accessToken'], ENV['HADNU_FACEBOOK_SECRET'])
      profile = graph.get_object("me", {fields: "id,name,email"}, api_version: "v2.6")
      user = User.from_facebook(profile)
    elsif params[:provider] == 'google'
      uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo')
      query_params = { id_token: params['accessToken'] }
      uri.query = URI.encode_www_form(query_params)
      google_response = Net::HTTP.get(uri)
      profile = JSON.parse(google_response)
      user = User.from_google(profile)
    end

    if user
      auth_token = Knock::AuthToken.new payload: { sub: user.id }
      render json: auth_token, status: :created
    else
      render json: {error: 'user not found or could not be created'}, status: :error
    end
  end
end
