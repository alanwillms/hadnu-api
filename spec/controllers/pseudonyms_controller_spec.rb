require 'rails_helper'

describe PseudonymsController do
  describe '#index' do
    it 'lists pseudonyms with publications' do
      pseudonym = create(:pseudonym_with_publications)
      get :index
      expect(json_response.first).to include(
        'id' => pseudonym.id,
        'name' => pseudonym.name
      )
    end

    it 'accepts a random order option' do
      pseudonym = create(:pseudonym_with_publications)
      get :index, params: { random: '1' }
      expect(json_response.first).to include(
        'id' => pseudonym.id,
        'name' => pseudonym.name
      )
    end

    it 'does not list pseudonyms without publications' do
      create(:pseudonym)
      get :index
      expect(json_response).to eq([])
    end

    it 'has a 200 status' do
      create(:pseudonym)
      get :index
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:pseudonym) { create(:pseudonym_with_publications, updated_at: 1.hour.ago) }
      before(:each) do
        pseudonym
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if an pseudonym gets updated' do
        pseudonym.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new pseudonym is created' do
        create(:pseudonym_with_publications)
        get :index
        expect(response.status).to be(200)
      end
    end
  end
end
