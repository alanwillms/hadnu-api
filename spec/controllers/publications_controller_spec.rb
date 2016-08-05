require 'rails_helper'

describe PublicationsController do
  describe '#index' do
    it 'lists published and unblocked publications' do
      publication = create(:publication, published: true, blocked: false)
      get :index
      expect(json_response.first).to include(
        'id' => publication.id,
        'title' => publication.title
      )
    end

    it 'lists publications by author' do
      create(:author_with_publications)
      author = create(:author_with_publications)
      publication = author.publications.first
      get :index, params: { author_id: author.id }
      expect(json_response.length).to be(1)
      expect(json_response.first).to include(
        'id' => publication.id,
        'title' => publication.title
      )
    end

    it 'lists publications by category' do
      create(:category_with_publications)
      category = create(:category_with_publications)
      publication = category.publications.first
      get :index, params: { category_id: category.id }
      expect(json_response.length).to be(1)
      expect(json_response.first).to include(
        'id' => publication.id,
        'title' => publication.title
      )
    end

    it 'does not list unpublished publications' do
      create(:publication, published: false, blocked: false)
      get :index
      expect(json_response).to eq([])
    end

    it 'does not list blocked publications' do
      create(:publication, published: true, blocked: true)
      get :index
      expect(json_response).to eq([])
    end

    context 'cache' do
      let(:publication) do
        create(:publication, updated_at: 1.hour.ago)
      end

      before(:each) do
        publication
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a publication gets updated' do
        publication.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created' do
        create(:publication)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#show' do
    it 'display publication' do
      publication = create(:publication, published: true, blocked: false)
      get :show, params: { id: publication.id }
      expect(json_response).to include(
        'id' => publication.id,
        'title' => publication.title
      )
    end

    it 'increments the hit counter' do
      publication = create(
        :publication,
        published: true,
        blocked: false,
        hits: 99
      )
      get :show, params: { id: publication.id }
      publication.reload
      expect(publication.hits).to eq(100)
    end

    context 'cache' do
      let(:publication) do
        create(:publication, updated_at: 1.hour.ago)
      end

      let(:section) do
        create(:section, publication: publication, updated_at: 1.hour.ago)
      end

      before(:each) do
        section
        get :show, params: { id: publication.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: publication.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@publication, nil)
        publication.touch
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end

      it 'expires if one of its sections gets updated' do
        section.touch
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new section is created for it' do
        create(
          :section,
          publication: publication, root: section, parent: section
        )
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end
    end
  end
end
