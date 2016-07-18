require 'rails_helper'

describe UserRegistrationsController do
  describe '#create' do
    context 'with valid data' do
      before :each do
        payload = {
          user_registration: {
            name: 'John Doe',
            login: 'johndoe',
            password: 's3cr3t',
            email: 'john@doe.com'
          }
        }
        post :create, params: payload
      end

      it 'has a 201 status' do
        expect(response.status).to be(201)
      end

      it 'renders user data' do
        expect(json_response).to include(
          'login' => 'johndoe'
        )
      end
    end

    context 'without data' do
      def create
        payload = {
          user_registration: {
            name: 'John Doe',
            login: '',
            password: 's3cr3t',
            email: 'john@doe.com'
          }
        }
        post :create, params: payload
      end

      it 'has a 422 status' do
        create
        expect(response.status).to be(422)
      end

      it 'renders error for empty login' do
        create
        expect(json_response).to eq(
          'login' => ["can't be blank", 'is invalid']
        )
      end

      it 'does not trigger recaptcha validation' do
        expect(controller).not_to receive(:verify_recaptcha)
        create
      end
    end

    context 'with invalid data' do
      before :each do
        payload = {
          user_registration: {
            name: 'John Doe',
            login: '',
            password: 's3cr3t',
            email: 'john@doe.com'
          }
        }
        post :create, params: payload
      end

      it 'has a 422 status' do
        expect(response.status).to be(422)
      end

      it 'renders errors' do
        expect(json_response).to include(
          'login' => ['can\'t be blank', 'is invalid']
        )
      end
    end
  end
end
