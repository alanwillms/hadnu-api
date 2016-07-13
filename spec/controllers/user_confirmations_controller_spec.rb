require 'rails_helper'

describe UserConfirmationsController do
  describe '#create' do
    let(:user) do
      create(
        :user,
        login: 'johndoe',
        confirmation_code: 'token', email_confirmed: false
      )
    end

    context 'with a valid token' do
      before(:each) do
        post :create,
             params: { user_confirmation: { token: user.confirmation_code } }
      end

      it 'has a 201 status' do
        expect(response.status).to be(201)
      end

      it 'renders the user login' do
        expect(json_response).to include(
          'login' => user.login
        )
      end

      it 'removes user#confirmation_code' do
        user.reload
        expect(user.confirmation_code).to be_nil
      end

      it 'sets user#email_confirmed to true' do
        user.reload
        expect(user.email_confirmed).to be(true)
      end
    end

    context 'with an invalid token' do
      before(:each) do
        post :create, params: { user_confirmation: { token: 'invalid' } }
      end

      it 'has a 400 status' do
        expect(response.status).to be(400)
      end
    end
  end
end
