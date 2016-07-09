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
  end
end
