require 'rails_helper'

describe OmniauthSessionsController do
  describe '#create' do
    context 'Facebook' do
      let(:payload) { { provider: 'facebook', accessToken: 'token' } }

      context 'with valid access token' do
        let(:facebook_response) do
          {
            'id' => 12_345_678,
            'email' => 'john@doe.com',
            'name' => 'John Doe',
            'verified' => true
          }
        end

        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return(facebook_response)
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
        end

        context 'and existing account' do
          before(:each) do
            create(:user, facebook_id: 12_345_678)
            post :create, params: payload
          end

          it 'has a 201 status' do
            expect(response.status).to be(201)
          end

          it 'renders JWT token' do
            expect(json_response).to have_key('jwt')
          end
        end

        context 'and existing blocked account' do
          before(:each) do
            create(:user, facebook_id: 12_345_678, blocked: true)
            post :create, params: payload
          end

          it 'has a 403 status' do
            expect(response.status).to be(403)
          end

          it 'says an error ocurred' do
            expect(json_response).to eq(
              'token' => ['something went wrong, please try again later']
            )
          end
        end

        context 'and existing unconfirmed account' do
          before(:each) do
            create(:user, facebook_id: 12_345_678, email_confirmed: false)
            post :create, params: payload
          end

          it 'has a 403 status' do
            expect(response.status).to be(403)
          end

          it 'says account email is not confirmed' do
            expect(json_response).to eq(
              'token' => ['please check your email and confirm your account']
            )
          end
        end

        context 'and nonexistent account' do
          before(:each) do
            post :create, params: payload
          end

          it 'has a 422 status' do
            expect(response.status).to be(422)
          end

          it 'returns Facebook data in the body' do
            expect(json_response).to eq(
              'name' => 'John Doe',
              'email' => 'john@doe.com'
            )
          end
        end
      end

      context 'with invalid access token' do
        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return({})
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
          post :create, params: payload
        end

        it 'has a 403 status' do
          expect(response.status).to be(403)
        end

        it 'says an error ocurred' do
          expect(json_response).to eq(
            'token' => ['something went wrong, please try again later']
          )
        end
      end

      context 'with unverified Facebook account' do
        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return(
            'id' => 12_345_678,
            'email' => 'john@doe.com',
            'name' => 'John Doe',
            'verified' => false
          )
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
          create(:user, facebook_id: 12_345_678)
          post :create, params: payload
        end

        it 'has a 403 status' do
          expect(response.status).to be(403)
        end

        it 'says Facebook account is not verified' do
          expect(json_response).to eq(
            'token' => ['you must confirm your account before using it here']
          )
        end
      end
    end

    context 'Google' do
      let(:payload) { { provider: 'google', accessToken: 'token' } }

      context 'with valid access token' do
        let(:google_response) do
          {
            'sub' => 12_345_678,
            'email' => 'john@doe.com',
            'name' => 'John Doe',
            'email_verified' => true
          }
        end

        before(:each) do
          allow(Net::HTTP).to receive(:get).and_return(
            JSON.generate(google_response)
          )
        end

        context 'and existing account' do
          before(:each) do
            create(:user, google_id: 12_345_678)
            post :create, params: payload
          end

          it 'has a 201 status' do
            expect(response.status).to be(201)
          end

          it 'renders JWT token' do
            expect(json_response).to have_key('jwt')
          end
        end

        context 'and existing blocked account' do
          before(:each) do
            create(:user, google_id: 12_345_678, blocked: true)
            post :create, params: payload
          end

          it 'has a 403 status' do
            expect(response.status).to be(403)
          end

          it 'says an error ocurred' do
            expect(json_response).to eq(
              'token' => ['something went wrong, please try again later']
            )
          end
        end

        context 'and existing unconfirmed account' do
          before(:each) do
            create(:user, google_id: 12_345_678, email_confirmed: false)
            post :create, params: payload
          end

          it 'has a 403 status' do
            expect(response.status).to be(403)
          end

          it 'says account email is not confirmed' do
            expect(json_response).to eq(
              'token' => ['please check your email and confirm your account']
            )
          end
        end

        context 'and nonexistent account' do
          before(:each) do
            post :create, params: payload
          end

          it 'has a 422 status' do
            expect(response.status).to be(422)
          end

          it 'returns Google data in the body' do
            expect(json_response).to eq(
              'name' => 'John Doe',
              'email' => 'john@doe.com'
            )
          end
        end
      end

      context 'with invalid access token' do
        before(:each) do
          allow(Net::HTTP).to receive(:get).and_return(
            JSON.generate({})
          )
          post :create, params: payload
        end

        it 'has a 403 status' do
          expect(response.status).to be(403)
        end

        it 'says an error ocurred' do
          expect(json_response).to eq(
            'token' => ['something went wrong, please try again later']
          )
        end
      end

      context 'with unverified Google account' do
        before(:each) do
          allow(Net::HTTP).to receive(:get).and_return(
            JSON.generate(
              'sub' => 12_345_678,
              'email' => 'john@doe.com',
              'name' => 'John Doe',
              'email_verified' => false
            )
          )
          create(:user, google_id: 12_345_678)
          post :create, params: payload
        end

        it 'has a 403 status' do
          expect(response.status).to be(403)
        end

        it 'says Google account is not verified' do
          expect(json_response).to eq(
            'token' => ['you must confirm your account before using it here']
          )
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
        expect(json_response).to eq(
          'token' => ['something went wrong, please try again later']
        )
      end

      it 'has a 403 status' do
        post :create, params: payload
        expect(response.status).to be(403)
      end
    end
  end
end
