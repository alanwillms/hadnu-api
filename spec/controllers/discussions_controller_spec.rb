require 'rails_helper'

describe DiscussionsController do
  describe '#index' do
    context 'when not cached or filtered by subject' do
      it 'lists all discussions' do
        discussion = create(:discussion)
        get :index
        expect(json_response.first).to include(
          'id' => discussion.id,
          'title' => discussion.title
        )
      end

      it 'has a 200 status' do
        get :index
        expect(response.status).to be(200)
      end
    end

    context 'when filtered by subject' do
      it 'lists only its discussions' do
        create(:discussion)
        create(:discussion)
        subject = create(:subject)
        discussion = create(:discussion, subject: subject)
        get :index, params: { subject_id: subject.id }
        expect(json_response.first).to include(
          'id' => discussion.id,
          'title' => discussion.title
        )
      end
    end

    context 'when cached' do
      let(:discussion) do
        create(:discussion, updated_at: 1.hour.ago)
      end

      before(:each) do
        discussion
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a discussion gets updated' do
        discussion.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new discussion is created' do
        create(:discussion)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#create' do
    let(:subject) { create(:subject) }
    let(:valid_params) do
      {
        discussion: {
          title: 'How much is 2 + 2?',
          comment: 'I am not sure of the answer',
          subject_id: subject.id
        }
      }
    end

    context 'with valid data' do
      before(:each) do
        authenticate
        post :create, params: valid_params
      end

      it 'returns a 201 status' do
        expect(response.status).to eq(201)
      end

      it 'creates a new discussion' do
        expect(Discussion.count).to eq(1)
      end

      it 'creates a new comment' do
        expect(Comment.count).to eq(1)
      end

      it 'outputs discussion data' do
        expect(json_response).to include(
          'title' => valid_params[:discussion][:title]
        )
      end
    end

    context 'with invalid discussion data' do
      let(:invalid_params) do
        params = valid_params
        params[:discussion][:title] = nil
        params
      end

      before(:each) do
        authenticate
        post :create, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not create a discussion' do
        expect(Discussion.count).to eq(0)
      end

      it 'does not create a comment' do
        expect(Comment.count).to eq(0)
      end

      it 'outputs errors' do
        expect(json_response).to include('title' => ["can't be blank"])
      end
    end

    context 'with invalid comment data' do
      let(:invalid_params) do
        params = valid_params
        params[:discussion][:comment] = nil
        params
      end

      before(:each) do
        authenticate
        post :create, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not create a discussion' do
        expect(Discussion.count).to eq(0)
      end

      it 'does not create a comment' do
        expect(Comment.count).to eq(0)
      end

      it 'outputs errors' do
        expect(json_response).to include('comment' => ["can't be blank"])
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#update' do
    let(:discussion) do
      create(:discussion, title: 'Original title')
    end

    def valid_params
      {
        id: discussion.id,
        discussion: {
          title: 'New Title',
          subject_id: discussion.subject_id
        }
      }
    end

    context 'with guest user' do
      before(:each) do
        patch :update, params: valid_params
        discussion.reload
      end

      it 'returns a 401 status' do
        expect(response.status).to eq(401)
      end

      it 'does not update the discussion' do
        expect(discussion.title).to eq('Original title')
      end
    end

    context 'with a different user' do
      before(:each) do
        authenticate
        patch :update, params: valid_params
        discussion.reload
      end

      it 'returns a 401 status' do
        expect(response.status).to eq(401)
      end

      it 'does not update the discussion' do
        expect(discussion.title).to eq('Original title')
      end
    end

    context 'with an admin user' do
      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        params = valid_params
        params[:discussion][:closed] = true
        patch :update, params: params
        discussion.reload
      end

      it 'returns a 200 status' do
        expect(response.status).to eq(200)
      end

      it 'updates the discussion including closing it' do
        expect(discussion.title).to eq('New Title')
        expect(discussion.closed).to eq(true)
      end
    end

    context 'with creator user' do
      context 'with valid data and within 24 hours of posting' do
        before(:each) do
          authenticate discussion.user
          patch :update, params: valid_params
          discussion.reload
        end

        it 'returns a 200 status' do
          expect(response.status).to eq(200)
        end

        it 'updates the discussion' do
          expect(discussion.title).to eq('New Title')
        end
      end

      context 'trying to close a discussion' do
        before(:each) do
          authenticate discussion.user
          params = valid_params
          params[:discussion][:closed] = true
          patch :update, params: params
          discussion.reload
        end

        it 'returns a 200 status' do
          expect(response.status).to eq(200)
        end

        it 'does not close the discussion' do
          expect(discussion.closed).not_to eq(true)
        end
      end

      context 'after 24 hours' do
        let(:discussion) do
          create(:discussion, title: 'Original title', created_at: 2.days.ago)
        end

        before(:each) do
          authenticate discussion.user
          patch :update, params: valid_params
          discussion.reload
        end

        it 'returns a 401 status' do
          expect(response.status).to eq(401)
        end

        it 'does not update the discussion' do
          expect(discussion.title).not_to eq('New Title')
        end
      end
    end

    context 'with invalid data' do
      before(:each) do
        authenticate discussion.user
        invalid_params = valid_params
        invalid_params[:discussion][:subject_id] = nil
        patch :update, params: invalid_params
        discussion.reload
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not update the discussion' do
        expect(discussion.title).to eq('Original title')
      end
    end
  end

  describe '#show' do
    it 'display discussion' do
      discussion = create(:discussion)
      get :show, params: { id: discussion.id }
      expect(json_response).to include(
        'id' => discussion.id,
        'title' => discussion.title
      )
    end

    it 'has a 200 status' do
      discussion = create(:discussion)
      get :show, params: { id: discussion.id }
      expect(response.status).to be(200)
    end

    it 'increments the hit counter' do
      discussion = create(:discussion, hits: 99)
      get :show, params: { id: discussion.id }
      discussion.reload
      expect(discussion.hits).to eq(100)
    end

    context 'cache' do
      let(:discussion) { create(:discussion, updated_at: 1.hour.ago) }

      before(:each) do
        get :show, params: { id: discussion.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: discussion.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@discussion, nil)
        discussion.touch
        get :show, params: { id: discussion.id }
        expect(response.status).to be(200)
      end
    end
  end
end
