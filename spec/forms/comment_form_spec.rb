require 'rails_helper'

describe CommentForm do
  let(:comment_form) do
    discussion = create(:discussion)
    user = discussion.user
    params = {comment: 'My comment'}
    CommentForm.new(discussion, user, params)
  end

  describe '#save' do
    it 'delegates to #comment' do
      expect(comment_form.comment).to receive(:save)
      comment_form.save
    end
  end

  describe '#errors' do
    it 'delegates to #comment' do
      expect(comment_form.comment).to receive(:errors)
      comment_form.errors
    end
  end
end
