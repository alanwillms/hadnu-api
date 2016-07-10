require 'rails_helper'

describe CommentPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:comment) { create(:comment) }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Comment)
      expect(policy).to permit(normal_user, Comment)
      expect(policy).to permit(admin_user, Comment)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, comment)
      expect(policy).to permit(normal_user, comment)
      expect(policy).to permit(admin_user, comment)
    end
  end

  permissions :new?, :create? do
    it 'denies access to guest' do
      expect(policy).not_to permit(nil, Comment.new)
    end

    it 'allow access to normal user and admin user' do
      expect(policy).to permit(normal_user, Comment.new)
      expect(policy).to permit(admin_user, Comment.new)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, comment)
      expect(policy).not_to permit(normal_user, comment)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, comment)
    end
  end
end
