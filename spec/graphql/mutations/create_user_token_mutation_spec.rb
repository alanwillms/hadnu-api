describe CreateUserTokenMutation do
  let(:mutation) { Schema.mutation.fields['createUserToken'] }

  describe '#resolve' do
    context 'with valid login credentials' do
      before(:each) do
        user = create(:user)
        @result = mutation.resolve(nil, { login: user.login, password: 'password' }, nil)
      end

      it 'returns JWT token' do
        expect(@result.token).not_to be_nil
      end

      it 'does not return errors' do
        expect(@result.errors).to be_empty
      end
    end

    context 'with valid email credentials' do
      before(:each) do
        user = create(:user)
        @result = mutation.resolve(nil, { login: user.email, password: 'password' }, nil)
      end

      it 'returns JWT token' do
        expect(@result.token).not_to be_nil
      end

      it 'does not return errors' do
        expect(@result.errors).to be_empty
      end
    end

    context 'with invalid credentials' do
      it 'returns errors for unconfirmed account' do
        user = create(:user, email_confirmed: false)
        result = mutation.resolve(nil, { login: user.login, password: 'password' }, nil)
        expect(result.errors).not_to be_empty
        expect(result.token).to be_nil
      end

      it 'returns errors for blocked account' do
        user = create(:user, blocked: true)
        result = mutation.resolve(nil, { login: user.login, password: 'password' }, nil)
        expect(result.errors).not_to be_empty
        expect(result.token).to be_nil
      end

      it 'returns errors for invalid username' do
        result = mutation.resolve(nil, { login: '', password: 'password' }, nil)
        expect(result.errors).not_to be_empty
        expect(result.token).to be_nil
      end

      it 'returns errors for invalid password' do
        create(:user, login: 'john')
        result = mutation.resolve(nil, { login: 'john', password: 'invalid' }, nil)
        expect(result.errors).not_to be_empty
        expect(result.token).to be_nil
      end
    end
  end
end
