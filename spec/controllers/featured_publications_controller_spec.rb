require 'rails_helper'

describe FeaturedPublicationsController do
  describe '#index' do
    it 'lists featured publications' do
      publication = create(:publication, featured: true)
      get :index
      expect(json_response.first).to include(
        'id' => publication.id,
        'title' => publication.title
      )
    end
  end
end
