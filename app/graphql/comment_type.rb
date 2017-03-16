CommentType = GraphQL::ObjectType.define do
  name 'Comment'
  description 'A discussion comment'
  field :id, !types.ID
  field :comment, !types.String
  field :created_at, !types.String
  field :updated_at, !types.String

  field :user, !UserType
end
