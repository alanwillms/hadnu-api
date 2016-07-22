require 'rails_helper'

describe FeaturedPublicationsController do
  describe '#index' do
    let(:featured_publication) do
      create(:publication, featured: true, updated_at: 1.hour.ago)
    end

    it 'lists featured publications' do
      featured_publication
      get :index
      expect(json_response.first).to include(
        'id' => featured_publication.id,
        'title' => featured_publication.title
      )
    end

    it 'has a 200 status' do
      featured_publication
      get :index
      expect(response.status).to be(200)
    end

    context 'cache' do
      before(:each) do
        featured_publication
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a publication gets updated' do
        featured_publication.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created' do
        create(:publication, featured: true)
        get :index
        expect(response.status).to be(200)
      end
    end
  end
end
