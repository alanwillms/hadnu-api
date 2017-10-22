require 'rails_helper'

describe UserDeactivationsController do
  describe '#create' do
    context 'with authenticated user' do
      let(:user) { create(:user) }
      before(:each) do
        authenticate user
        post :create
      end

      it 'has a 200 status' do
        expect(response.status).to be(200)
      end

      it 'blocks user' do
        user.reload
        expect(user.blocked).to be(true)
      end
    end

    context 'without authenticated user' do
      it 'has a 401 status' do
        post :create
        expect(response.status).to be(401)
      end
    end
  end
end
