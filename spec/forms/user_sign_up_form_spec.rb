require 'rails_helper'

describe UserSignUpForm do
  describe '#save' do
    let(:user_params) do
      {
        name: 'John Doe',
        login: 'john_doe',
        email: 'john@doe.com',
        password: 's3cr3t',
        registration_ip: '127.0.0.1'
      }
    end

    it 'delegates to user.save' do
      form = described_class.new(user_params)
      expect(form.user).to receive(:save).once
      form.save
    end

    it 'generates a user.confirmation_code' do
      form = described_class.new(user_params)
      expect(form.save).to be(true)
      expect(form.user.confirmation_code).to be_present
    end

    it 'sends an email message with confirmation instructions' do
      form = described_class.new(user_params)
      expect(form.save).to be(true)
      expect(ActionMailer::Base.deliveries).not_to be_empty
      message = ActionMailer::Base.deliveries.last
      expect(message).to deliver_to(user_params[:email])
      expect(message).to have_subject(I18n.t('email.confirm_email.subject'))
    end
  end

  describe '#errors' do
    it 'capture user validation errors' do
      form = described_class.new({})
      form.save
      expect(form.errors.messages).to eq(
        email: ["can't be blank", 'is invalid'],
        login: ["can't be blank", 'is invalid'],
        name: ["can't be blank"],
        password: ["can't be blank"],
        registration_ip: ["can't be blank", 'is invalid format.']
      )
    end
  end
end
