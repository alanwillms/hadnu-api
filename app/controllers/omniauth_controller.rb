require 'net/http'

class OmniauthController < ApplicationController
  def create
    skip_authorization
    expires_now
    begin
      user = get_user(params[:provider])
      render json: user_token(user), status: :created
    rescue
      body = { error: 'User not found or could not be created' }
      render json: body, status: :unprocessable_entity
    end
  end

  private

  def get_user(provider)
    if provider == 'facebook'
      user_from_facebook
    elsif provider == 'google'
      user_from_google
    else
      raise StandardError, 'Invalid provider'
    end
  end

  def user_from_facebook
    graph = Koala::Facebook::API.new(
      params['accessToken'],
      ENV['HADNU_FACEBOOK_SECRET']
    )
    profile = graph.get_object(
      'me',
      { fields: 'id,name,email' },
      api_version: 'v2.6'
    )
    User.from_facebook(profile, request)
  end

  def user_from_google
    uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo')
    query_params = { id_token: params['accessToken'] }
    uri.query = URI.encode_www_form(query_params)
    google_response = Net::HTTP.get(uri)
    profile = JSON.parse(google_response)
    User.from_google(profile, request)
  end

  def user_token(user)
    Knock::AuthToken.new payload: { sub: user.id }
  end
end
