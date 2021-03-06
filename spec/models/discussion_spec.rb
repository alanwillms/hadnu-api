require 'rails_helper'

describe Discussion do
  context 'validations' do
    before { create(:discussion) }

    it { should belong_to(:subject) }
    it { should belong_to(:user) }
    it { should belong_to(:last_user) }

    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:last_user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:hits) }
    it { should validate_presence_of(:comments_count) }
    it { should validate_presence_of(:commented_at) }
    it { should validate_uniqueness_of(:title).case_insensitive }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should allow_value('1989-07-03 22:50:00').for(:commented_at) }
    it { should_not allow_value('foo').for(:commented_at) }
    it { should validate_inclusion_of(:closed).in_array([true, false]) }
    it do
      should validate_numericality_of(:hits)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:comments_count)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
  end

  describe '.recent_first' do
    it 'returns recently commented first' do
      create(:discussion, title: 'third', commented_at: 1.hours.ago)
      create(:discussion, title: 'second', commented_at: 2.hours.ago)
      create(:discussion, title: 'first', commented_at: 3.hours.ago)

      titles = Discussion.recent_first.all.map(&:title)
      expect(titles).to eq(%w(third second first))
    end
  end

  describe '#hit!' do
    it 'increments the hit counter' do
      discussion = create(:discussion, hits: 99)
      expect { discussion.hit! }.to change { discussion.hits }.to(100)
    end
  end

  describe '#save' do
    it 'updates user discussions count' do
      user = create(:user)
      3.times { create(:discussion, user: user) }
      expect(user.reload.discussions_count).to eq(3)
    end

    it 'updates subject discussions count' do
      discussion_subject = create(:subject)
      3.times { create(:discussion, subject: discussion_subject) }
      expect(discussion_subject.reload.discussions_count).to eq(3)
    end
  end

  describe '#slug' do
    it 'returns a slug representation of the object' do
      discussion = build(:discussion, id: 123, title: 'Açaí')
      expect(discussion.slug).to eq('123-acai')
    end
  end
end
