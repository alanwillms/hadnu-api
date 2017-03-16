require 'rails_helper'

describe ImagePolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:image) { Image.new }

  permissions :index? do
    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, Image)
    end

    it 'denies access to guest, normal user and admin user' do
      expect(policy).not_to permit(nil, Image)
      expect(policy).not_to permit(normal_user, Image)
    end
  end

  permissions :show? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, image)
      expect(policy).to permit(normal_user, image)
      expect(policy).to permit(admin_user, image)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, image)
      expect(policy).not_to permit(normal_user, image)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, image)
    end
  end
end
