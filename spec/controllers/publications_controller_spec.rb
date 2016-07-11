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

    it 'lists by random order' do
      publication = create(:publication, published: true, blocked: false)
      get :index, params: { order: 'random' }
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
  end
end
