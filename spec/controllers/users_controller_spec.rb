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

  describe '#update' do
    let(:edited_user) { create(:user) }

    let(:valid_params) do
      {
        id: edited_user.id,
        user: {
          photo_base64: {
            base64: 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
            name: 'file.jpg'
          }
        }
      }
    end

    context 'with valid data' do
      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        patch :update, params: valid_params
      end

      it 'returns a 200 status' do
        expect(response.status).to eq(200)
      end

      it 'updates the user' do
        edited_user.reload
        expect(edited_user.photo.original_filename).to eq('file.jpg')
      end

      it 'outputs user data' do
        expect(json_response).to include(
          'login' => edited_user.login
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:user][:photo_base64][:base64] = 'data:plain/text;base64,/9j/4TI9RX'
        params
      end

      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        patch :update, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not update the user' do
        old_photo = edited_user.photo
        edited_user.reload
        expect(edited_user.photo).to eq(old_photo)
      end

      it 'outputs errors' do
        expect(json_response.keys).to eq(['photo'])
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        patch :update, params: valid_params
        expect(response.status).to eq(401)
      end
    end

    context 'with unauthorized user' do
      it 'returns a 401 status' do
        authenticate
        expect { patch :update, params: valid_params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
