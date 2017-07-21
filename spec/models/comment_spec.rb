require 'rails_helper'

describe Comment do
  context 'validations' do
    before { create(:comment) }

    it { should belong_to(:discussion) }
    it { should belong_to(:user) }

    it { should validate_presence_of(:discussion) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:comment) }
    it { should validate_length_of(:comment).is_at_most(8000) }
    it do
      should validate_uniqueness_of(:comment)
        .scoped_to(:discussion_id)
        .case_insensitive
    end
  end

  describe '.old_first' do
    it 'returns oldest records first' do
      create(:comment, comment: 'third', created_at: 1.hours.ago)
      create(:comment, comment: 'second', created_at: 2.hours.ago)
      create(:comment, comment: 'first', created_at: 3.hours.ago)

      expect(Comment.old_first.all.map(&:comment)).to eq(%w(first second third))
    end
  end

  describe '.save' do
    it 'updates user comments count' do
      user = create(:user)
      3.times { create(:comment, user: user) }
      expect(user.reload.comments_count).to eq(3)
    end

    it 'updates user commented discussions count' do
      user = create(:user)
      discussion = create(:discussion)
      create(:comment, user: user)
      create(:comment, user: user, discussion: discussion)
      create(:comment, user: user, discussion: discussion)
      expect(user.reload.commented_discussions_count).to eq(2)
    end

    it 'updates discussion comments count' do
      discussion = create(:discussion)
      3.times { create(:comment, discussion: discussion) }
      expect(discussion.reload.comments_count).to eq(3)
    end

    it 'updates subject comments count' do
      discussion_subject = create(:subject)
      discussion = create(:discussion, subject: discussion_subject)
      3.times { create(:comment, discussion: discussion) }
      expect(discussion_subject.reload.comments_count).to eq(3)
    end
  end
end
