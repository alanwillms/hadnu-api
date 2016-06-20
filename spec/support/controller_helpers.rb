module ControllerHelpers
  def authenticate(user = nil)
    request.headers['authorization'] = 'Bearer JWTTOKEN'
    knock = double("Knock")
    user = create(:user) unless user
    yield user if block_given?
    allow(knock).to receive(:current_user).and_return(user)
    allow(knock).to receive(:validate!).and_return(true)
    allow(Knock::AuthToken).to receive(:new).and_return(knock)
    allow(knock).to receive(:entity_for).and_return(user)
    user
  end

  def json_response
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
