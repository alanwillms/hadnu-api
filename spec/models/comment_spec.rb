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
    end

    # @TODO Move to comment form and discussion form
    # it 'does not allow a new comment for 1 minute for the user' do
    #   user = create(:user)
    #   create(:comment, user: user)
    #   comment = build(:comment, user: user)
    #   expect(comment.save).to be(false)
    #   expect(comment.errors.messages).to eq(
    #     comment: ['please wait one minute before posting another comment']
    #   )
    # end
    #
    # it 'allow a new comment after the user waits 1 minute' do
    #   user = create(:user)
    #   create(:comment, user: user, created_at: 1.minute.ago)
    #   comment = build(:comment, user: user)
    #   expect(comment.save).to be(true)
    # end
  end

  describe '.old_first' do
    it 'returns oldest records first' do
      create(:comment, comment: 'third', created_at: 1.hours.ago)
      create(:comment, comment: 'second', created_at: 2.hours.ago)
      create(:comment, comment: 'first', created_at: 3.hours.ago)

      expect(Comment.old_first.all.map(&:comment)).to eq(%w(first second third))
    end
  end
end
