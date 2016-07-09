require 'rails_helper'

describe RecentSectionsController do
  describe '#index' do
    it 'display sections marked with a published_at date' do
      publication = create(:publication)
      section = create(:section, publication: publication, published_at: Time.now)
      get :index
      expect(json_response.first).to include(
        'id' => section.id,
        'title' => section.title
      )
    end
  end
end
