class OmniauthSignInForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :token, :provider

  validates :token, presence: true
  validates :provider, presence: true

  def user
    if provider == 'facebook'
      from_facebook
    elsif provider == 'google'
      from_google
    else
      message = I18n.t('omniauth.errors.invalid_provider')
      errors.add(:token, message)
      nil
    end
  end

  def user_data
    {
      name: user&.name,
      email: user&.email
    }
  end

  private

  def from_facebook
    graph = Koala::Facebook::API.new(
      token,
      ENV['HADNU_FACEBOOK_SECRET']
    )
    profile = graph.get_object(
      'me',
      { fields: 'id,name,email,verified' },
      api_version: 'v2.6'
    )

    if profile['id'].nil?
      message = I18n.t('omniauth.errors.invalid_token')
      errors.add(:token, message)
      return
    end

    unless profile['verified']
      message = I18n.t('omniauth.errors.unverified_omniauth')
      errors.add(:token, message)
      return
    end

    user = User
           .where(facebook_id: profile['id'])
           .or(User.where(email: profile['email']))
           .first_or_initialize

    if user.blocked
      message = I18n.t('omniauth.errors.blocked_user')
      errors.add(:token, message)
      return
    end

    if !user.new_record? && !user.email_confirmed
      message = I18n.t('omniauth.errors.unverified_user')
      errors.add(:token, message)
      return
    end

    if user.new_record?
      user.name = profile['name']
      user.email = profile['email']
    else
      user.facebook_id = profile['id']
      user.save
    end

    user
  end

  def from_google
    uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo')
    uri.query = URI.encode_www_form(id_token: token)
    profile = JSON.parse(Net::HTTP.get(uri))

    if profile['sub'].nil?
      message = I18n.t('omniauth.errors.invalid_token')
      errors.add(:token, message)
      return
    end

    unless profile['email_verified']
      message = I18n.t('omniauth.errors.unverified_omniauth')
      errors.add(:token, message)
      return
    end

    user = User
           .where(google_id: profile['sub'])
           .or(User.where(email: profile['email']))
           .first_or_initialize

    if user.blocked
      message = I18n.t('omniauth.errors.blocked_user')
      errors.add(:token, message)
      return
    end

    if !user.new_record? && !user.email_confirmed
      message = I18n.t('omniauth.errors.unverified_user')
      errors.add(:token, message)
      return
    end

    if user.new_record?
      user.name = profile['name']
      user.email = profile['email']
    else
      user.google_id = profile['sub']
      user.save
    end

    user
  end
end
