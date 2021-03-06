require 'rails_helper'

describe UserMailer do
  describe 'registration_confirmation' do
    let(:user) { create(:user, confirmation_code: 'supertoken') }
    let(:mail) { described_class.registration_confirmation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('email.confirm_email.subject'))
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match([
        ENV['HADNU_EMAIL_CONFIRMATION_URL'],
        user.confirmation_code
      ].join)
    end
  end

  describe 'reset_password' do
    let(:user) { create(:user, confirmation_code: 'supertoken') }
    let(:mail) { described_class.reset_password(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('email.reset_password.subject'))
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match([
        ENV['HADNU_PASSWORD_RESET_URL'],
        user.password_recovery_code
      ].join)
    end
  end
end
