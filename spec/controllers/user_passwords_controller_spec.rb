require 'rails_helper'

describe UserPasswordsController do
  describe '#create' do
    context 'with existent user' do
      before :each do
        user = create(:user)
        post :create, params: { user_password: { email: user.email } }
      end

      it 'has a 201 status' do
        expect(response.status).to be(201)
      end

      it 'renders empty object' do
        expect(response.body).to eq('{}')
      end
    end

    context 'with invalid user' do
      before :each do
        post :create, params: { user_password: { email: 'invalid@site.com' } }
      end

      it 'has a 422 status' do
        expect(response.status).to be(422)
      end

      it 'renders errors' do
        expect(response.body).to eq('{}')
      end
    end
  end

  describe '#update' do
    context 'with valid token' do
      let(:user) { create(:user, password_recovery_code: 'token') }
      before :each do
        payload = {
          user_password: {
            token: user.password_recovery_code,
            password: 's3cr3t',
            password_confirmation: 's3cr3t'
          }
        }
        post :update, params: payload
      end

      it 'has a 200 status' do
        expect(response.status).to be(200)
      end

      it 'renders user data' do
        expect(json_response).to include(
          'id' => user.id,
          'login' => user.login
        )
      end
    end

    context 'with invalid token' do
      let(:user) { create(:user, password_recovery_code: 'token') }
      before :each do
        payload = {
          user_password: {
            token: user.password_recovery_code + 'invalid',
            password: 's3cr3t',
            password_confirmation: 's3cr3t'
          }
        }
        post :update, params: payload
      end

      it 'has a 422 status' do
        expect(response.status).to be(422)
      end

      it 'renders errors' do
        expect(json_response).to include(
          'token' => ['Token expired or invalid']
        )
      end
    end
  end
end
