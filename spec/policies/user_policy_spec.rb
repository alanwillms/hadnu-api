require 'rails_helper'

describe UserPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:user) { User.new }

  permissions :show? do
    it 'denies access to guest user' do
      expect(policy).not_to permit(nil, User)
    end

    it 'allow access to normal user and admin user' do
      expect(policy).to permit(normal_user, User)
      expect(policy).to permit(admin_user, User)
    end
  end

  permissions :index?, :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest, normal and admin user' do
      expect(policy).not_to permit(nil, user)
      expect(policy).not_to permit(normal_user, user)
      expect(policy).not_to permit(admin_user, user)
    end
  end
end
