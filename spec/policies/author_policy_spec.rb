require 'rails_helper'

describe AuthorPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:author) { Author.new }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Author)
      expect(policy).to permit(normal_user, Author)
      expect(policy).to permit(admin_user, Author)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, author)
      expect(policy).to permit(normal_user, author)
      expect(policy).to permit(admin_user, author)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, author)
      expect(policy).not_to permit(normal_user, author)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, author)
    end
  end

  describe '.scope' do
    let(:author_with_publications) { create(:author_with_publications) }

    before(:each) do
      author_with_publications
      create(:author)
      create(:author_with_blocked_publications)
      create(:author_with_unpublished_publications)
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, Author).count).to be(4)
    end

    it 'lists only with unblocked & published publications to normal user' do
      scoped = Pundit.policy_scope(normal_user, Author)
      expect(scoped.count).to be(1)
      expect(scoped.first).to eq(author_with_publications)
    end
  end
end
