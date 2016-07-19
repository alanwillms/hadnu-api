require 'rails_helper'

describe AuthorsController do
  describe '#index' do
    it 'lists authors with publications' do
      author = create(:author_with_publications)
      get :index
      expect(json_response.first).to include(
        'id' => author.id,
        'pen_name' => author.pen_name
      )
    end

    it 'accepts a random order option' do
      author = create(:author_with_publications)
      get :index, params: { random: '1' }
      expect(json_response.first).to include(
        'id' => author.id,
        'pen_name' => author.pen_name
      )
    end

    it 'does not list authors without publications' do
      create(:author)
      get :index
      expect(json_response).to eq([])
    end

    it 'has a 200 status' do
      create(:author)
      get :index
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:author) { create(:author_with_publications, updated_at: 1.hour.ago) }
      before(:each) do
        author
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if an author gets updated' do
        author.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new author is created' do
        create(:author_with_publications)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#show' do
    let(:author) do
      record = create(:author_with_publications, updated_at: 1.hour.ago)
      publication = record.publications.first
      publication.updated_at = 1.hour.ago
      publication.save
      record
    end

    it 'display author with publications' do
      get :show, params: { id: author.id }
      expect(json_response).to include(
        'id' => author.id,
        'pen_name' => author.pen_name
      )
    end

    it 'has a 200 status' do
      get :show, params: { id: author.id }
      expect(response.status).to be(200)
    end

    context 'cache' do
      before(:each) do
        get :show, params: { id: author.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: author.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@author, nil)
        author.touch
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end

      it 'expires if one of his publications get updated' do
        publication = author.publications.first
        publication.touch
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created written by him or her' do
        create(
          :author_pseudonym_publication,
          author: author,
          pseudonym: create(:pseudonym, author: author)
        )
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end
    end
  end
end
