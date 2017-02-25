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

    context 'cache' do
      let(:publication) do
        create(:publication, updated_at: 1.hour.ago)
      end

      before(:each) do
        publication
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a publication gets updated' do
        publication.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created' do
        create(:publication)
        get :index
        expect(response.status).to be(200)
      end
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

    it 'increments the hit counter' do
      publication = create(
        :publication,
        published: true,
        blocked: false,
        hits: 99
      )
      get :show, params: { id: publication.id }
      publication.reload
      expect(publication.hits).to eq(100)
    end

    context 'cache' do
      let(:publication) do
        create(:publication, updated_at: 1.hour.ago)
      end

      let(:section) do
        create(:section, publication: publication, updated_at: 1.hour.ago)
      end

      before(:each) do
        section
        get :show, params: { id: publication.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: publication.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@publication, nil)
        publication.touch
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end

      it 'expires if one of its sections gets updated' do
        section.touch
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new section is created for it' do
        create(
          :section,
          publication: publication, root: section, parent: section
        )
        get :show, params: { id: publication.id }
        expect(response.status).to be(200)
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      {
        publication: {
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
        expect(Publication.count).to eq(1)
      end

      it 'outputs publication data' do
        expect(json_response).to include(
          'title' => valid_params[:publication][:title]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:publication][:title] = nil
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
        expect(Publication.count).to eq(0)
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
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#update' do
    let(:publication) { create(:publication) }

    let(:valid_params) do
      {
        id: publication.id,
        publication: {
          title: publication.title + ' Changed'
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
        publication.reload
        expect(publication.title).to eq(valid_params[:publication][:title])
      end

      it 'outputs publication data' do
        expect(json_response).to include(
          'title' => valid_params[:publication][:title]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:publication][:title] = nil
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
        publication.reload
        expect(publication.title).not_to eq(valid_params[:publication][:title])
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
        patch :update, params: valid_params
        expect(response.status).to eq(401)
      end
    end
  end
end
