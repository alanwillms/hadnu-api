require 'rails_helper'

describe DiscussionsController do
  describe '#index' do
    let(:discussion) { create(:discussion) }

    it 'lists discussions' do
      discussion = create(:discussion)
      get :index
      expect(json_response.first).to include(
        'id' => discussion.id,
        'title' => discussion.title
      )
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

  describe '#show' do
    it 'display discussion' do
      discussion = create(:discussion)
      get :show, params: { id: discussion.id }
      expect(json_response).to include(
        'id' => discussion.id,
        'title' => discussion.title
      )
    end
  end
end
