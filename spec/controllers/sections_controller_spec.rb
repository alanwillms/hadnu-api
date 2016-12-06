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

  describe '#create' do
    let(:valid_params) do
      {
        publication_id: create(:publication).id,
        section: {
          title: 'The Dark Tower'
        }
      }
    end

    context 'with valid data' do
      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        post :create, params: valid_params
      end

      it 'returns a 201 status' do
        expect(response.status).to eq(201)
      end

      it 'creates a new publication' do
        expect(Section.count).to eq(1)
      end

      it 'outputs publication data' do
        expect(json_response).to include(
          'title' => valid_params[:section][:title]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:section][:title] = nil
        params
      end

      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        post :create, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not create an publication' do
        expect(Section.count).to eq(0)
      end

      it 'outputs errors' do
        errors_data = { 'title' => ["can't be blank"] }
        expect(json_response).to include(errors_data)
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end

    context 'with unauthorized user' do
      it 'returns a 401 status' do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'editor')
        end
        expect { post :create, params: valid_params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe '#update' do
    let(:publication) { create(:publication) }
    let(:section) { create(:section, publication: publication) }

    let(:valid_params) do
      {
        id: section.id,
        publication_id: publication.id,
        section: {
          title: section.title + ' Changed'
        }
      }
    end

    context 'with valid data' do
      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        patch :update, params: valid_params
      end

      it 'returns a 200 status' do
        expect(response.status).to eq(200)
      end

      it 'updates the publication' do
        section.reload
        expect(section.title).to eq(valid_params[:section][:title])
      end

      it 'outputs publication data' do
        expect(json_response).to include(
          'title' => valid_params[:section][:title]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:section][:title] = nil
        params
      end

      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        patch :update, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not update the publication' do
        section.reload
        expect(section.title).not_to eq(valid_params[:section][:title])
      end

      it 'outputs errors' do
        errors_data = { 'title' => ["can't be blank"] }
        expect(json_response).to include(errors_data)
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        patch :update, params: valid_params
        expect(response.status).to eq(401)
      end
    end

    context 'with unauthorized user' do
      it 'returns a 401 status' do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'editor')
        end
        expect { patch :update, params: valid_params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
