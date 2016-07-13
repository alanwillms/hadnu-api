require 'rails_helper'

describe UserRequestNewPasswordForm do
  describe '#save' do
    let(:user) { create(:user, email: 'john@doe.com') }
    let(:form) { described_class.new(email: user.email) }

    it 'validates the presence of email' do
      invalid_form = described_class.new(email: '')
      expect(invalid_form.save).to be(false)
    end

    it 'sets user#password_recovery_code' do
      form.save
      user.reload
      expect(user.password_recovery_code).to be_present
    end

    it 'sends an email message with password reset instructions' do
      expect(form.save).to be(true)
      expect(ActionMailer::Base.deliveries).not_to be_empty
      message = ActionMailer::Base.deliveries.last
      expect(message).to deliver_to(user[:email])
      expect(message).to have_subject(I18n.t('email.reset_password.subject'))
    end
  end
end
