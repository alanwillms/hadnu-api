require 'rails_helper'

describe SubjectPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:subject) { Subject.new }

  permissions :show?, :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, Subject)
      expect(policy).to permit(normal_user, Subject)
      expect(policy).to permit(admin_user, Subject)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access to guest and normal user' do
      expect(policy).not_to permit(nil, subject)
      expect(policy).not_to permit(normal_user, subject)
    end

    it 'allow access to admin user' do
      expect(policy).to permit(admin_user, subject)
    end
  end
end
