require 'rails_helper'

describe SectionsController do
  describe '#show' do
    it 'display section' do
      section = create(:section)
      get :show, params: { publication_id: section.publication.id, id: section.id }
      expect(json_response).to include(
        'id' => section.id,
        'title' => section.title
      )
    end
  end
end
