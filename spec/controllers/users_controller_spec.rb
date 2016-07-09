require 'rails_helper'

describe UsersController do
  describe '#show' do
    it 'display user' do
      authenticate
      user = create(:user)
      get :show, params: { id: user.id }
      expect(json_response).to include(
        'id' => user.id,
        'login' => user.login
      )
    end
  end
end
