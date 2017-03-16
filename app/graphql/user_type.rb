UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'An application user'

  field :id, !types.ID
  field :login, !types.String, property: :login
  field :comments, types[!CommentType]
end
