require 'rails_helper'

describe CommentsController do
  let(:valid_params) do
    discussion = create(:discussion)
    params = {
      discussion_id: discussion.id,
      comment: {comment: 'My great comment'}
    }
  end

  describe '#create' do
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
        parsed_body = JSON.parse(response.body)
        comment_data = {
          'comment' => valid_params[:comment][:comment],
        }
        expect(parsed_body).to include(comment_data)
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
        parsed_body = JSON.parse(response.body)
        errors_data = {"comment" => ["can't be blank"]}
        expect(parsed_body).to include(errors_data)
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
