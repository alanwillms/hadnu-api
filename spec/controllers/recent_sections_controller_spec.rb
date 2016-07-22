require 'rails_helper'

describe RecentSectionsController do
  describe '#index' do
    let(:publication) { create(:publication, updated_at: 1.hour.ago) }
    let(:section) do
      create(
        :section,
        publication: publication, published_at: Time.now, updated_at: 1.hour.ago
      )
    end

    before(:each) do
      section
      get :index
    end

    it 'display sections marked with a published_at date' do
      expect(json_response.first).to include(
        'id' => section.id,
        'title' => section.title
      )
    end

    it 'has a 200 status' do
      expect(response.status).to be(200)
    end

    context 'cache' do
      before(:each) { set_request_etag_headers }

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a section gets updated' do
        section.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new recent section is created' do
        create(
          :section,
          publication: publication,
          published_at: Time.now,
          root: section,
          parent: section
        )
        get :index
        expect(response.status).to be(200)
      end
    end
  end
end
