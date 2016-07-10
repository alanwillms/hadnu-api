require 'rails_helper'

describe ApplicationPolicy do
  let(:user) { create(:user) }
  let(:policy) { described_class }
  let(:record) { Author.new }

  permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies for all' do
      expect(policy).not_to permit(nil, record)
      expect(policy).not_to permit(user, record)
    end
  end

  describe 'scope' do
    it 'delegates to Pundit.policy_scope!' do
      expect(Pundit).to receive(:policy_scope!).once
      policy.new(user, record).scope
    end
  end
end
