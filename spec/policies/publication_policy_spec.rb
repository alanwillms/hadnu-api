require 'rails_helper'

describe PublicationPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:publication) { Publication.new }
  let(:published_publication) { create(:publication) }
  let(:blocked_publication) { create(:publication, blocked: true) }
  let(:unpublished_publication) { create(:publication, published: false) }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Publication)
      expect(policy).to permit(normal_user, Publication)
      expect(policy).to permit(admin_user, Publication)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user for published publication' do
      expect(policy).to permit(nil, published_publication)
      expect(policy).to permit(normal_user, published_publication)
      expect(policy).to permit(admin_user, published_publication)
    end

    it 'allow access to admin user for blocked publication' do
      expect(policy).to permit(admin_user, blocked_publication)
    end

    it 'denies access to guest and normal user for blocked publication' do
      expect(policy).not_to permit(nil, blocked_publication)
      expect(policy).not_to permit(normal_user, blocked_publication)
    end

    it 'allow access to admin user for unpublished publication' do
      expect(policy).to permit(admin_user, unpublished_publication)
    end

    it 'denies access to guest and normal user for unpublished publication' do
      expect(policy).not_to permit(nil, unpublished_publication)
      expect(policy).not_to permit(normal_user, unpublished_publication)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, publication)
      expect(policy).not_to permit(normal_user, publication)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, publication)
    end
  end

  describe '.scope' do
    before(:each) do
      published_publication
      create(:publication, blocked: true)
      create(:publication, published: false)
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, Publication).count).to be(3)
    end

    it 'lists only with unblocked & published publications to normal user' do
      scoped = Pundit.policy_scope(normal_user, Publication)
      expect(scoped.count).to be(1)
      expect(scoped.first).to eq(published_publication)
    end
  end
end
