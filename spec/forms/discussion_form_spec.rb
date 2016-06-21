require 'rails_helper'

describe DiscussionForm do
  let(:subject) { create(:subject) }
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      title: 'Valid title',
      comment: 'Valid comment',
      subject_id: subject.id
    }
  end
  let(:discussion_form) { DiscussionForm.new(user, valid_params) }

  describe '#save' do
    context 'with valid data' do
      let(:discussion_form) { DiscussionForm.new(user, valid_params) }

      it 'creates a new discussion' do
        expect { discussion_form.save }.to change { Discussion.count }.by(1)
      end

      it 'creates a new comment' do
        expect { discussion_form.save }.to change { Comment.count }.by(1)
      end

      it 'sets discussion subject' do
        discussion_form.save
        expect(discussion_form.discussion.subject).to eq(subject)
      end

      it 'sets discussion user' do
        discussion_form.save
        expect(discussion_form.discussion.last_user).to eq(user)
      end

      it 'sets discussion last user as the user itself' do
        discussion_form.save
        expect(discussion_form.discussion.last_user).to eq(user)
      end

      it 'sets discussion commented at' do
        discussion_form.save
        expect(discussion_form.discussion.commented_at).not_to be_nil
      end

      it 'sets discussion comments counter to 1' do
        discussion_form.save
        expect(discussion_form.discussion.comments_counter).to be 1
      end

      it 'returns true' do
        expect(discussion_form.save).to be true
      end
    end

    context 'with invalid discussion data' do
      let(:discussion_form) do
        params = valid_params
        params[:title] = nil
        DiscussionForm.new(user, params)
      end

      it 'does not create a discussion' do
        expect { discussion_form.save }.not_to change { Discussion.count }
      end

      it 'does not create a comment' do
        expect { discussion_form.save }.not_to change { Comment.count }
      end

      it 'returns false' do
        expect(discussion_form.save).to be false
      end
    end
  end

  context 'with invalid comment data' do
    let(:discussion_form) do
      params = valid_params
      params[:comment] = nil
      DiscussionForm.new(user, params)
    end

    it 'does not create a discussion' do
      expect { discussion_form.save }.not_to change { Discussion.count }
    end

    it 'does not create a comment' do
      expect { discussion_form.save }.not_to change { Comment.count }
    end

    it 'returns false' do
      expect(discussion_form.save).to be false
    end
  end

  describe '#errors' do
    it 'returns discussion errors' do
      params = valid_params
      params[:title] = nil
      discussion_form = DiscussionForm.new(user, params)
      discussion_form.save
      expect(discussion_form.errors).to include(:title)
    end

    it 'returns comment errors' do
      params = valid_params
      params[:comment] = nil
      discussion_form = DiscussionForm.new(user, params)
      discussion_form.save
      expect(discussion_form.errors).to include(:comment)
    end
  end
end
