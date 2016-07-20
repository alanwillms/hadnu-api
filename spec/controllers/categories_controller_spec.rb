require 'rails_helper'

describe CategoriesController do
  describe '#index' do
    it 'does not list categories without publications' do
      create(:category)
      get :index
      expect(json_response).to eq([])
    end

    it 'list categories with publications' do
      category = create(:category_with_publications)
      get :index
      expect(json_response.first).to include(
        'id' => category.id,
        'name' => category.name
      )
    end

    context 'cache' do
      let(:category) do
        create(:category_with_publications, updated_at: 1.hour.ago)
      end

      before(:each) do
        category
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a category gets updated' do
        category.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new category is created' do
        create(:category_with_publications)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#show' do
    it 'display category with publications' do
      category = create(:category_with_publications)
      get :show, params: { id: category.id }
      expect(json_response).to include(
        'id' => category.id,
        'name' => category.name
      )
    end

    context 'cache' do
      let(:category) do
        record = create(:category_with_publications, updated_at: 1.hour.ago)
        publication = record.publications.first
        publication.updated_at = 1.hour.ago
        publication.save
        record
      end

      before(:each) do
        get :show, params: { id: category.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: category.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@category, nil)
        category.touch
        get :show, params: { id: category.id }
        expect(response.status).to be(200)
      end

      it 'expires if one of his publications get updated' do
        publication = category.publications.first
        publication.touch
        get :show, params: { id: category.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created written by him or her' do
        create(:category_publication, category: category)
        get :show, params: { id: category.id }
        expect(response.status).to be(200)
      end
    end
  end
end
