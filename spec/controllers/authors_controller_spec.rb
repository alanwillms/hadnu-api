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
  end

  describe '#show' do
    it 'display author with publications' do
      author = create(:author_with_publications)
      get :show, params: { id: author.id }
      expect(json_response).to include(
        'id' => author.id,
        'pen_name' => author.pen_name
      )
    end
  end
end
