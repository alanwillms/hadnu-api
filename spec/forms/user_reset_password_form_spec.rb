require 'rails_helper'

describe UserResetPasswordForm do
  describe '#save' do
    let(:user) { create(:user, password_recovery_code: 'token') }
    before(:each) { user }
    let(:params) do
      {
        password: 'new',
        password_confirmation: 'new',
        token: user.password_recovery_code
      }
    end

    it 'returns false for invalid token' do
      params[:token] = ''
      form = described_class.new(params)
      expect(form.save).to be(false)
    end

    it 'returns false for invalid data' do
      params[:password_confirmation] = 'invalid'
      form = described_class.new(params)
      expect(form.save).to be(false)
    end

    it 'returns true if the password has been changed' do
      form = described_class.new(params)
      form.save
      expect(form.save).to be(true)
    end

    it 'changes the password when data is valid' do
      form = described_class.new(params)
      form.save
      old_password = user.encrypted_password
      user.reload
      new_password = user.encrypted_password
      expect(old_password).not_to eq(new_password)
    end

    it 'erases user#password_recovery_code when data is valid' do
      form = described_class.new(params)
      form.save
      user.reload
      expect(user.password_recovery_code).to be_nil
    end
  end

  describe '.i18n_scope' do
    it 'is not empty' do
      expect(described_class.i18n_scope).to be_present
    end
  end
end
