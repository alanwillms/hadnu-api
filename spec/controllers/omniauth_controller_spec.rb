require 'rails_helper'

describe OmniauthController do
  describe '#create' do
    context 'Facebook' do
      let(:payload) do
        {
          provider: 'facebook',
          accessToken: 'token'
        }
      end

      context 'with valid access token' do
        it 'renders JWT token' do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return(
            'id' => 12_345_678,
            'email' => 'john@doe.com',
            'name' => 'John Doe'
          )
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
          post :create, params: payload
          expect(json_response).to have_key('jwt')
        end
      end

      context 'with invalid access token' do
        it 'has a 422 status' do
          post :create, params: payload
          expect(response.status).to be(422)
        end
      end
    end

    context 'Google' do
      let(:payload) do
        {
          provider: 'google',
          accessToken: 'token'
        }
      end

      context 'with valid access token' do
        it 'renders JWT token' do
          allow(Net::HTTP).to receive(:get).and_return(
            JSON.generate(
              'id' => 12_345_678,
              'email' => 'john@doe.com',
              'name' => 'John Doe'
            )
          )
          post :create, params: payload
          expect(json_response).to have_key('jwt')
        end
      end

      context 'with invalid access token' do
        it 'has a 422 status' do
          post :create, params: payload
          expect(response.status).to be(422)
        end
      end
    end

    context 'invalid provider' do
      let(:payload) do
        {
          provider: 'invalid',
          accessToken: 'token'
        }
      end

      it 'renders error message' do
        post :create, params: payload
        expect(json_response).to have_key('error')
      end

      it 'has a 422 status' do
        post :create, params: payload
        expect(response.status).to be(422)
      end
    end
  end
end
