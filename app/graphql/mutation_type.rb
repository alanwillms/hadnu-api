MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The root of all mutations'

  field :createUserToken, field: CreateUserTokenMutation.field
end
