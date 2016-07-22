require 'rails_helper'

describe SectionsController do
  describe '#show' do
    let(:publication) do
      create(:publication, updated_at: 1.hour.ago)
    end

    let(:section) do
      create(:section, publication: publication, updated_at: 1.hour.ago)
    end

    it 'display section' do
      get :show, params: { publication_id: publication.id, id: section.id }
      expect(json_response).to include(
        'id' => section.id,
        'title' => section.title
      )
    end

    context 'cache' do
      let(:sub_section) do
        create(
          :section,
          publication: publication, root: section, parent: section
        )
      end

      before(:each) do
        section
        get :show, params: { publication_id: publication.id, id: section.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { publication_id: publication.id, id: section.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@section, nil)
        section.touch
        get :show, params: { publication_id: publication.id, id: section.id }
        expect(response.status).to be(200)
      end

      it 'expires if its publication gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@publication, nil)
        publication.touch
        get :show, params: { publication_id: publication.id, id: section.id }
        expect(response.status).to be(200)
      end

      it 'expires if another of its publication sections gets updated' do
        sub_section.touch
        get :show, params: { publication_id: publication.id, id: section.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new section is created for its publication' do
        create(
          :section,
          publication: publication, root: section, parent: sub_section
        )
        get :show, params: { publication_id: publication.id, id: section.id }
        expect(response.status).to be(200)
      end
    end
  end
end
