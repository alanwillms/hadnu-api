require 'rails_helper'

describe UsersController do
  describe '#show' do
    let(:user) { create(:user, updated_at: 1.hour.ago) }
    before(:each) do
      authenticate
      get :show, params: { id: user.id }
    end

    it 'display user' do
      expect(json_response).to include(
        'id' => user.id,
        'login' => user.login
      )
    end

    it 'has a 200 status' do
      expect(response.status).to be(200)
    end

    context 'cache' do
      before(:each) { set_request_etag_headers }

      it 'has a 304 status' do
        get :show, params: { id: user.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@user, nil)
        user.touch
        get :show, params: { id: user.id }
        expect(response.status).to be(200)
      end
    end
  end
end
