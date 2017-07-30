class OmniauthSignUpForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :token, :provider, :name, :login, :password, :registration_ip

  validates :token, presence: true
  validates :provider, presence: true, inclusion: { in: %w[facebook google] }
  validates :name, presence: true
  validates :login, presence: true
  validates :password, presence: true
  validates :registration_ip, presence: true

  def save
    if validate && valid_profile? && form.save
      form.user.send("#{provider}_id=", profile[:id])
      return form.user.save
    end
    false
  end

  def user
    form.user
  end

  def errors
    errors = super
    return errors unless form.errors
    form.errors.each do |attribute, error|
      next if !respond_to?(attribute) || errors.added?(attribute, error)
      errors.add(attribute, error)
    end
    errors
  end

  private

  def valid_profile?
    return add_token_error('invalid_token') if profile[:id].nil?
    return add_token_error('unverified_omniauth') unless profile[:verified]
    return add_token_error('duplicated_user') if user_already_exists?
    true
  end

  def add_token_error(message_key)
    errors.add :token, I18n.t("omniauth.errors.#{message_key}")
    false
  end

  def user_already_exists?
    User
      .where("#{provider}_id".to_sym => profile[:id])
      .or(User.where(email: profile[:email]))
      .exists?
  end

  def form
    return @form if @form
    @form = UserSignUpForm.new
    @form.email = profile[:email]
    @form.name = name
    @form.login = login
    @form.password = password
    @form.registration_ip = registration_ip
    @form
  end

  def profile
    return @profile if @profile
    @profile = from_facebook if provider == 'facebook'
    @profile = from_google if provider == 'google'
    @profile ||= { id: nil, verified: nil, email: nil }
  rescue
    @profile = { id: nil, verified: nil, email: nil }
  end

  def from_facebook
    response = facebok_api.get_object(
      'me',
      { fields: 'id,name,email,verified' },
      api_version: 'v2.6'
    )
    {
      id: response['id'],
      verified: response['verified'],
      email: response['email']
    }
  end

  def from_google
    uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo')
    uri.query = URI.encode_www_form(id_token: token)
    response = JSON.parse(Net::HTTP.get(uri))
    {
      id: response['sub'],
      verified: response['email_verified'],
      email: response['email']
    }
  end

  def facebok_api
    Koala::Facebook::API.new(token, ENV['HADNU_FACEBOOK_SECRET'])
  end
end
