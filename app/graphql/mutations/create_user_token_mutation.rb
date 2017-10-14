CreateUserTokenMutation = GraphQL::Relay::Mutation.define do
  name 'CreateUserToken'
  description 'Authenticate user and create a new JWT token'

  input_field :login, !types.String
  input_field :password, !types.String

  return_type GraphqlHelper.create_mutation_result_type(
    name: 'UserToken',
    description: 'JWT token to be used for authentication and authorization',
    item_field: :token,
    item_type: types.String,
    item_description: 'JWT Token'
  )

  resolve(
    lambda do |_object, inputs, _context|
      errors = [
        {
          attribute: :login,
          message: I18n.t('user_token.errors.invalid_login_or_password')
        }
      ]
      token = nil

      user = User.find_by_login_or_email inputs[:login]

      if user.present? && user.authenticate(inputs[:password])
        auth_token = Knock::AuthToken.new payload: user.to_token_payload
        token = auth_token.token
        errors = []
      end

      GraphqlHelper.hash_to_struct(
        token: token,
        errors: errors
      )
    end
  )
end
