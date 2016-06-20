require 'rails_helper'

describe UserTokenController do
  describe '#create' do
    context 'with valid credentials' do
      before(:each) do
        user = create(:user)
        post :create, params: {auth: {login: user.login, password: 'password'}}
      end

      it 'returns JWT token' do
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to have_key('jwt')
      end

      it 'has a 200 status' do
        expect(response.status).to be(201)
      end
    end

    context 'with invalid credentials' do
      it 'has a 404 status for invalid username' do
        post :create, params: {}
        expect(response.status).to be(404)
      end

      it 'has a 404 status for invalid password' do
        create(:user, login: 'john')
        post :create, params: {auth: {login: 'john', password: 'invalid'}}
        expect(response.status).to be(404)
      end
    end
  end
end
