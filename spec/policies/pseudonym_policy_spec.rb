require 'rails_helper'

describe PseudonymPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:pseudonym) { Pseudonym.new }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Pseudonym)
      expect(policy).to permit(normal_user, Pseudonym)
      expect(policy).to permit(admin_user, Pseudonym)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, pseudonym)
      expect(policy).to permit(normal_user, pseudonym)
      expect(policy).to permit(admin_user, pseudonym)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, pseudonym)
      expect(policy).not_to permit(normal_user, pseudonym)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, pseudonym)
    end
  end

  describe '.scope' do
    let(:pseudonym_with_publications) { create(:pseudonym_with_publications) }
    let(:pseudonym_with_signed_reader_only_publications) { create(:pseudonym_with_signed_reader_only_publications) }

    before(:each) do
      pseudonym_with_publications
      create(:pseudonym)
      create(:pseudonym_with_blocked_publications)
      create(:pseudonym_with_unpublished_publications)
      pseudonym_with_signed_reader_only_publications
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, Pseudonym).count).to be(5)
    end

    it 'lists only unblocked & published + signed reader only publications to normal user' do
      scoped = Pundit.policy_scope(normal_user, Pseudonym)
      expect(scoped.count).to be(2)
      expect(scoped.first).to eq(pseudonym_with_publications)
      expect(scoped.last).to eq(pseudonym_with_signed_reader_only_publications)
    end

    it 'lists only unblocked & published publications to normal user' do
      scoped = Pundit.policy_scope(nil, Pseudonym)
      expect(scoped.count).to be(1)
      expect(scoped.first).to eq(pseudonym_with_publications)
    end
  end
end
