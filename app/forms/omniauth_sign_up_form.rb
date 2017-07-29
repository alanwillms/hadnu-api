class OmniauthSignUpForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :token, :provider, :name, :login, :password, :registration_ip

  validates :token, presence: true
  validates :provider, presence: true, inclusion: { in: %w(facebook google) }
  validates :name, presence: true
  validates :login, presence: true
  validates :password, presence: true
  validates :registration_ip, presence: true

  def save
    if valid_profile? && form.save
      if provider == 'facebook'
        form.user.facebook_id = profile[:id]
        form.user.save
      elsif provider == 'google'
        form.user.google_id = profile[:id]
        form.user.save
      end
      return true
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
    if profile[:id].nil?
      errors.add :token, I18n.t('omniauth.errors.invalid_token')
      return false
    end

    unless profile[:verified]
      errors.add :token, I18n.t('omniauth.errors.unverified_omniauth')
      return false
    end

    params = {}

    if provider == 'facebook'
      params[:facebook_id] = profile[:id]
    elsif provider == 'google'
      params[:google_id] = profile[:id]
    end

    user = User
           .where(params)
           .or(User.where(email: profile[:email]))
           .first

    if user
      errors.add :token, I18n.t('omniauth.errors.duplicated_user')
      return false
    end

    true
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
    @profile ||= {}
  end

  def from_facebook
    graph = Koala::Facebook::API.new(token, ENV['HADNU_FACEBOOK_SECRET'])
    profile = graph.get_object(
      'me',
      { fields: 'id,name,email,verified' },
      api_version: 'v2.6'
    )
    {
      id: profile['id'],
      verified: profile['verified'],
      email: profile['email']
    }
  rescue
    { id: nil, verified: nil, email: nil }
  end

  def from_google
    uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo')
    uri.query = URI.encode_www_form(id_token: token)
    profile = JSON.parse(Net::HTTP.get(uri))
    {
      id: profile['sub'],
      verified: profile['email_verified'],
      email: profile['email']
    }
  end
end
