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

    it 'has a 200 status' do
      create(:author)
      get :index
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:author) { create(:author_with_publications, updated_at: 1.hour.ago) }
      before(:each) do
        author
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if an author gets updated' do
        author.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new author is created' do
        create(:author_with_publications)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#show' do
    let(:author) do
      record = create(:author_with_publications, updated_at: 1.hour.ago)
      publication = record.publications.first
      publication.updated_at = 1.hour.ago
      publication.save
      record
    end

    it 'display author with publications' do
      get :show, params: { id: author.id }
      expect(json_response).to include(
        'id' => author.id,
        'pen_name' => author.pen_name
      )
    end

    it 'has a 200 status' do
      get :show, params: { id: author.id }
      expect(response.status).to be(200)
    end

    context 'with non existent record' do
      it 'returns a 404 status' do
        get :show, params: { id: 0 }
        expect(response.status).to be(404)
      end
    end

    context 'cache' do
      before(:each) do
        get :show, params: { id: author.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: author.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@author, nil)
        author.touch
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end

      it 'expires if one of his publications get updated' do
        publication = author.publications.first
        publication.touch
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new publication is created written by him or her' do
        create(
          :author_pseudonym_publication,
          author: author,
          pseudonym: create(:pseudonym, author: author)
        )
        get :show, params: { id: author.id }
        expect(response.status).to be(200)
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      {
        author: {
          pen_name: 'Stephen King',
          real_name: 'Stephen Edwin King',
          description: 'Stephen King is an American author of horror books.',
          born_on: '1947-09-21'
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

      it 'creates a new author' do
        expect(Author.count).to eq(1)
      end

      it 'outputs author data' do
        expect(json_response).to include(
          'pen_name' => valid_params[:author][:pen_name],
          'real_name' => valid_params[:author][:real_name]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:author][:pen_name] = nil
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

      it 'does not create an author' do
        expect(Author.count).to eq(0)
      end

      it 'outputs errors' do
        errors_data = { 'pen_name' => ["can't be blank"] }
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
    let(:author) { create(:author_with_publications) }

    let(:valid_params) do
      {
        id: author.id,
        author: {
          pen_name: author.pen_name + ' Changed',
          real_name: author.pen_name + ' Real',
          description: 'Foo bar baz'
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

      it 'updates the author' do
        author.reload
        expect(author.pen_name).to eq(valid_params[:author][:pen_name])
      end

      it 'outputs author data' do
        expect(json_response).to include(
          'pen_name' => valid_params[:author][:pen_name],
          'real_name' => valid_params[:author][:real_name]
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:author][:pen_name] = nil
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

      it 'does not update the author' do
        author.reload
        expect(author.real_name).not_to eq(valid_params[:author][:real_name])
      end

      it 'outputs errors' do
        errors_data = { 'pen_name' => ["can't be blank"] }
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
