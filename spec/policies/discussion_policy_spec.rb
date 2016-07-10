require 'rails_helper'

describe DiscussionPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:discussion) { create(:discussion) }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Discussion)
      expect(policy).to permit(normal_user, Discussion)
      expect(policy).to permit(admin_user, Discussion)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, discussion)
      expect(policy).to permit(normal_user, discussion)
      expect(policy).to permit(admin_user, discussion)
    end
  end

  permissions :new?, :create? do
    it 'denies access to guest' do
      expect(policy).not_to permit(nil, Discussion.new)
    end

    it 'allow access to normal user and admin user' do
      expect(policy).to permit(normal_user, Discussion.new)
      expect(policy).to permit(admin_user, Discussion.new)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, discussion)
      expect(policy).not_to permit(normal_user, discussion)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, discussion)
    end
  end
end
