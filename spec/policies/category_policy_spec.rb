require 'rails_helper'

describe CategoryPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:category) { Category.new }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Category)
      expect(policy).to permit(normal_user, Category)
      expect(policy).to permit(admin_user, Category)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, category)
      expect(policy).to permit(normal_user, category)
      expect(policy).to permit(admin_user, category)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, category)
      expect(policy).not_to permit(normal_user, category)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, category)
    end
  end

  describe '.scope' do
    let(:category_with_publications) { create(:category_with_publications) }
    let(:category_with_signed_reader_only_publications) { create(:category_with_signed_reader_only_publications) }

    before(:each) do
      category_with_publications
      create(:category)
      create(:category_with_blocked_publications)
      create(:category_with_unpublished_publications)
      category_with_signed_reader_only_publications
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, Category).count).to be(5)
    end

    it 'lists only unblocked & published + signed reader only publications to normal user' do
      scoped = Pundit.policy_scope(normal_user, Category)
      expect(scoped.count).to be(2)
      expect(scoped.first).to eq(category_with_publications)
      expect(scoped.last).to eq(category_with_signed_reader_only_publications)
    end

    it 'lists only unblocked & published publications to normal user' do
      scoped = Pundit.policy_scope(nil, Category)
      expect(scoped.count).to be(1)
      expect(scoped.first).to eq(category_with_publications)
    end
  end
end
