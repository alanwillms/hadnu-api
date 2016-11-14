require 'rails_helper'

describe CommentsController do
  describe '#index scoped by discusion' do
    let(:discussion) { create(:discussion) }

    it 'lists comments belonging to a given discussion' do
      comment = create(:comment, discussion: discussion)
      get :index, params: { discussion_id: discussion.id }
      expect(json_response.first).to include(
        'id' => comment.id,
        'comment' => comment.comment
      )
    end

    it 'does not list comments belonging to another discussion' do
      # from another discussion
      create(:comment)
      get :index, params: { discussion_id: discussion.id }
      expect(json_response).to be_empty
    end

    it 'has a 200 status' do
      get :index, params: { discussion_id: discussion.id }
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:comment) do
        create(:comment, discussion: discussion, updated_at: 1.hour.ago)
      end

      before(:each) do
        comment
        get :index, params: { discussion_id: discussion.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index, params: { discussion_id: discussion.id }
        expect(response.status).to be(304)
      end

      it 'expires if a comment gets updated' do
        comment.touch
        get :index, params: { discussion_id: discussion.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new comment is created' do
        create(:comment, discussion: discussion)
        get :index, params: { discussion_id: discussion.id }
        expect(response.status).to be(200)
      end
    end
  end

  describe '#index scoped by user' do
    let(:user) { create(:user) }

    it 'lists comments belonging to a given user' do
      comment = create(:comment, user: user)
      get :index, params: { user_id: user.id }
      expect(json_response.first).to include(
        'id' => comment.id,
        'comment' => comment.comment
      )
    end

    it 'does not list comments belonging to another user' do
      # from another user
      create(:comment)
      get :index, params: { user_id: user.id }
      expect(json_response).to be_empty
    end

    it 'displays recent first' do
      create(:comment, user: user, created_at: 2.hours.ago)
      create(:comment, user: user, created_at: 1.hour.ago)
      last_comment = create(:comment, user: user)
      get :index, params: { user_id: user.id }
      expect(json_response.first).to include(
        'id' => last_comment.id,
        'comment' => last_comment.comment
      )
    end

    it 'has a 200 status' do
      get :index, params: { user_id: user.id }
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:comment) do
        create(:comment, user: user, updated_at: 1.hour.ago)
      end

      before(:each) do
        comment
        get :index, params: { user_id: user.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index, params: { user_id: user.id }
        expect(response.status).to be(304)
      end

      it 'expires if a comment gets updated' do
        comment.touch
        get :index, params: { user_id: user.id }
        expect(response.status).to be(200)
      end

      it 'expires if a new comment is created' do
        create(:comment, user: user)
        get :index, params: { user_id: user.id }
        expect(response.status).to be(200)
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      {
        discussion_id: create(:discussion).id,
        comment: { comment: 'My great comment' }
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

      it 'creates a new comment' do
        expect(Comment.count).to eq(1)
      end

      it 'outputs comment data' do
        comment_data = {
          'comment' => valid_params[:comment][:comment]
        }
        expect(json_response).to include(comment_data)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:comment][:comment] = nil
        params
      end

      before(:each) do
        authenticate
        post :create, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not create a comment' do
        expect(Comment.count).to eq(0)
      end

      it 'outputs errors' do
        errors_data = { 'comment' => ["can't be blank"] }
        expect(json_response).to include(errors_data)
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end
  end
end
