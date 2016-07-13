require 'rails_helper'

describe CommentForm do
  let(:discussion) { create(:discussion) }
  let(:user) { create(:user) }
  let(:comment_form) do
    CommentForm.new(discussion, user, {comment: 'My comment'})
  end

  describe '#save' do
    context 'with valid data' do
      let(:comment_form) do
        params = { comment: 'Valid comment' }
        CommentForm.new(discussion, user, params)
      end

      it 'creates a new comment' do
        expect { comment_form.save }.to change { Comment.count }.by(1)
      end

      it 'sets discussion last user as the comment user' do
        expect { comment_form.save }.to change { discussion.last_user }.to(user)
      end

      it 'updates discussion commented at' do
        expect { comment_form.save }.to change { discussion.commented_at }
      end

      it 'increment discussion comments counter' do
        expect { comment_form.save }.to change { discussion.comments_counter }.by(1)
      end

      it 'returns true' do
        expect(comment_form.save).to be true
      end

      it 'does not allow a new comment for 1 minute for the user' do
        comment_form.save
        form = CommentForm.new(discussion, user, comment: 'Another comment now')
        expect(form.save).to be(false)
        expect(form.errors.messages).to eq(
          comment: ['please wait one minute before posting another comment']
        )
      end

      it 'allow a new comment after the user waits 1 minute' do
        create(:comment, user: user, created_at: 1.minute.ago)
        expect(comment_form.save).to be(true)
      end
    end

    context 'with invalid data' do
      let(:comment_form) do
        params = { comment: nil }
        CommentForm.new(discussion, user, params)
      end

      it 'does not create a comment' do
        expect { comment_form.save }.not_to change { Comment.count }
      end

      it 'returns false' do
        expect(comment_form.save).to be false
      end
    end
  end

  describe '#errors' do
    it 'delegates to #comment' do
      expect(comment_form.comment).to receive(:errors)
      comment_form.errors
    end
  end
end
