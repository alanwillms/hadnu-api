require 'rails_helper'

describe OmniauthSignUpForm do
  let(:form) { OmniauthSignUpForm.new }

  describe '.save' do
    context 'with Facebook' do
      before(:each) do
        form.token = 'foobar'
        form.provider = 'facebook'
        form.name = 'Jaspion'
        form.login = 'jaspion'
        form.password = 'secret'
        form.registration_ip = '127.0.0.1'
      end

      context 'successful integration' do
        let(:facebook_response) do
          {
            'id' => 156,
            'verified' => true,
            'email' => 'jaspion@example.com'
          }
        end

        before(:each) do
          graph = instance_double(Koala::Facebook::API)
          allow(graph).to receive(:get_object).and_return(facebook_response)
          allow(Koala::Facebook::API).to receive(:new).and_return(graph)
        end

        context 'when the Facebook account is valid and the user is new' do
          it 'creates a user associated with Facebook' do
            expect { form.save }.to change { User.count }.by(1)
            expect(User.first.facebook_id).to eq('156')
          end

          it 'returns true' do
            expect(form.save).to be(true)
          end
        end

        context 'when there is an user with the same email' do
          before(:each) { create(:user, email: 'jaspion@example.com') }

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end

        context 'when there is an user associated with the Facebook account' do
          before(:each) { create(:user, facebook_id: '156') }

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end

        context 'when the Facebook account is not verified' do
          let(:facebook_response) do
            {
              'id' => 156,
              'verified' => false,
              'email' => 'jaspion@example.com'
            }
          end

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end
      end

      context 'failed integration' do
        it 'does not create a new user' do
          expect { form.save }.not_to change { User.count }
        end

        it 'returns false' do
          expect(form.save).to be(false)
        end
      end
    end

    context 'with Google' do
      before(:each) do
        form.token = 'foobar'
        form.provider = 'google'
        form.name = 'Jaspion'
        form.login = 'jaspion'
        form.password = 'secret'
        form.registration_ip = '127.0.0.1'
      end

      context 'successful integration' do
        let(:google_response) do
          '{"sub": 418, "email_verified": true, "email": "jaspion@example.com"}'
        end

        before(:each) do
          allow(Net::HTTP).to receive(:get).and_return(google_response)
        end

        context 'when the Google account is valid and the user is new' do
          it 'creates a user associated with Google' do
            expect { form.save }.to change { User.count }.by(1)
            expect(User.first.google_id).to eq('418')
          end

          it 'returns true' do
            expect(form.save).to be(true)
          end
        end

        context 'when there is an user with the same email' do
          before(:each) { create(:user, email: 'jaspion@example.com') }

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end

        context 'when there is an user associated with the Google account' do
          before(:each) { create(:user, google_id: '418') }

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end

        context 'when the Google account is not verified' do
          let(:google_response) do
            '{"sub": 418, "email_verified": false, "email": "jaspion@example.com"}'
          end

          it 'does not create a new user' do
            expect { form.save }.not_to change { User.count }
          end

          it 'returns false' do
            expect(form.save).to be(false)
          end
        end
      end

      context 'failed integration' do
        it 'does not create a new user' do
          expect { form.save }.not_to change { User.count }
        end

        it 'returns false' do
          expect(form.save).to be(false)
        end
      end
    end
  end

  describe '.user' do
    it 'returns an User instance' do
      expect(form.user).to be_a(User)
    end
  end

  describe '.errors' do
    it 'returns an ActiveModel::Errors instance' do
      expect(form.errors).to be_a(ActiveModel::Errors)
    end
  end
end
