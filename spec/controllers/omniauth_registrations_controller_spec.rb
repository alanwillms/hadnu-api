require 'rails_helper'

describe OmniauthRegistrationsController do
  describe '#create' do
    context 'Facebook' do
      let(:facebook_response) do
        {
          'id' => 12_345_678,
          'email' => 'john@doe.com',
          'name' => 'John Doe',
          'verified' => true
        }
      end

      let(:params) do
        {
          user_registration: {
            name: 'John Doe',
            login: 'john',
            password: '123456',
            token: 'tok3n',
            provider: 'facebook'
          }
        }
      end

      before(:each) do
        graph = instance_double(Koala::Facebook::API)
        allow(graph).to receive(:get_object).and_return(facebook_response)
        allow(Koala::Facebook::API).to receive(:new).and_return(graph)
      end

      context 'existing email' do
        it 'returns 422' do
          create(:user, email: facebook_response['email'])
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, email: facebook_response['email'])
          post :create, params: params
          expect(json_response).to eq(
            'token' => [I18n.t('omniauth.errors.duplicated_user')]
          )
        end
      end

      context 'existing Facebook account' do
        it 'returns 422' do
          create(:user, facebook_id: facebook_response['id'])
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, facebook_id: facebook_response['id'])
          post :create, params: params
          expect(json_response).to eq(
            'token' => [I18n.t('omniauth.errors.duplicated_user')]
          )
        end
      end

      context 'existing login' do
        it 'returns 422' do
          create(:user, login: 'john')
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, login: 'john')
          post :create, params: params
          expect(json_response).to eq(
            'login' => ['has already been taken']
          )
        end
      end

      context 'successfully' do
        it 'returns 201' do
          post :create, params: params
          expect(response.status).to eq(201)
        end

        it 'renders user data' do
          post :create, params: params
          expect(json_response).to include(
            'login' => 'john'
          )
        end
      end

      context 'invalid token' do
        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return({})
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
        end

        it 'returns 422' do
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          post :create, params: params
          expect(json_response).to eq(
            'token' => ['something went wrong, please try again later']
          )
        end
      end

      context 'unverified account' do
        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          facebook_response['verified'] = false
          allow(graph).to receive(:get_object).and_return(facebook_response)
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
        end

        it 'returns 422' do
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          post :create, params: params
          expect(json_response).to eq(
            'token' => ['you must confirm your account before using it here']
          )
        end
      end

      context 'invalid data' do
        it 'returns 422' do
          params[:user_registration][:login] = 'LOGIN INVALID!'
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          params[:user_registration][:login] = 'LOGIN INVALID!'
          post :create, params: params
          expect(json_response).to eq(
            'login' => ['is invalid']
          )
        end
      end
    end

    context 'Google' do
      let(:google_response) do
        {
          'sub' => 12_345_678,
          'email' => 'john@doe.com',
          'name' => 'John Doe',
          'email_verified' => true
        }
      end

      let(:params) do
        {
          user_registration: {
            name: 'John Doe',
            login: 'john',
            password: '123456',
            token: 'tok3n',
            provider: 'google'
          }
        }
      end

      before(:each) do
        allow(Net::HTTP).to receive(:get).and_return(
          JSON.generate(google_response)
        )
      end

      context 'existing email' do
        it 'returns 422' do
          create(:user, email: google_response['email'])
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, email: google_response['email'])
          post :create, params: params
          expect(json_response).to eq(
            'token' => [I18n.t('omniauth.errors.duplicated_user')]
          )
        end
      end

      context 'existing Facebook account' do
        it 'returns 422' do
          create(:user, google_id: google_response['sub'])
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, google_id: google_response['sub'])
          post :create, params: params
          expect(json_response).to eq(
            'token' => [I18n.t('omniauth.errors.duplicated_user')]
          )
        end
      end

      context 'existing login' do
        it 'returns 422' do
          create(:user, login: 'john')
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          create(:user, login: 'john')
          post :create, params: params
          expect(json_response).to eq(
            'login' => ['has already been taken']
          )
        end
      end

      context 'successfully' do
        it 'returns 201' do
          post :create, params: params
          expect(response.status).to eq(201)
        end

        it 'renders user data' do
          post :create, params: params
          expect(json_response).to include(
            'login' => 'john'
          )
        end
      end

      context 'invalid token' do
        before(:each) do
          allow(Net::HTTP).to receive(:get).and_return('{}')
        end

        it 'returns 422' do
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          post :create, params: params
          expect(json_response).to eq(
            'token' => ['something went wrong, please try again later']
          )
        end
      end

      context 'unverified account' do
        before(:each) do
          google_response['email_verified'] = false
          allow(Net::HTTP).to receive(:get).and_return(
            JSON.generate(google_response)
          )
        end

        it 'returns 422' do
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          post :create, params: params
          expect(json_response).to eq(
            'token' => ['you must confirm your account before using it here']
          )
        end
      end

      context 'invalid data' do
        it 'returns 422' do
          params[:user_registration][:login] = 'LOGIN INVALID!'
          post :create, params: params
          expect(response.status).to eq(422)
        end

        it 'renders validation errors' do
          params[:user_registration][:login] = 'LOGIN INVALID!'
          post :create, params: params
          expect(json_response).to eq(
            'login' => ['is invalid']
          )
        end
      end
    end

    context 'invalid provider' do
      let(:params) do
        {
          user_registration: {
            name: 'John Doe',
            login: 'john',
            password: '123456',
            token: 'tok3n',
            provider: 'invalid'
          }
        }
      end

      it 'returns 422' do
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'renders validation errors' do
        post :create, params: params
        expect(json_response).to eq(
          'provider' => ['is not included in the list']
        )
      end
    end
  end
end
