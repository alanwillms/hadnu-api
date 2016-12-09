require 'rails_helper'

describe SectionPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:section) { Section.new }
  let(:published_section) { create(:section) }
  let(:blocked_section) { create(:blocked_section) }
  let(:unpublished_section) { create(:unpublished_section) }
  let(:signed_reader_only_section) { create(:signed_reader_only_section) }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Section)
      expect(policy).to permit(normal_user, Section)
      expect(policy).to permit(admin_user, Section)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user for published section' do
      expect(policy).to permit(nil, published_section)
      expect(policy).to permit(normal_user, published_section)
      expect(policy).to permit(admin_user, published_section)
    end

    it 'allow access to admin user for blocked section' do
      expect(policy).to permit(admin_user, blocked_section)
    end

    it 'denies access to guest and normal user for blocked section' do
      expect(policy).not_to permit(nil, blocked_section)
      expect(policy).not_to permit(normal_user, blocked_section)
    end

    it 'allow access to admin user for unpublished section' do
      expect(policy).to permit(admin_user, unpublished_section)
    end

    it 'denies access to guest and normal user for unpublished section' do
      expect(policy).not_to permit(nil, unpublished_section)
      expect(policy).not_to permit(normal_user, unpublished_section)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, section)
      expect(policy).not_to permit(normal_user, section)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, section)
    end
  end

  describe '.scope' do
    before(:each) do
      published_section
      blocked_section
      unpublished_section
      signed_reader_only_section
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, Section).count).to be(4)
    end

    it 'lists only unblocked & published + signed reader only sections to normal user' do
      scoped = Pundit.policy_scope(normal_user, Section)
      expect(scoped.count).to be(2)
      expect(scoped.first).to eq(published_section)
      expect(scoped.last).to eq(signed_reader_only_section)
    end

    it 'lists only unblocked & published sections to normal user' do
      scoped = Pundit.policy_scope(nil, Section)
      expect(scoped.count).to be(1)
      expect(scoped.first).to eq(published_section)
    end
  end
end
