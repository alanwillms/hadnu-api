require 'rails_helper'

describe SearchResultsController do
  describe '#index' do
    it 'has a 200 status' do
      create(:pg_search_document)
      get :index, params: { term: 'life' }
      expect(response.status).to be(200)
    end
  end
end
