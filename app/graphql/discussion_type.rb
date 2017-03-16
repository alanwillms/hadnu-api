DiscussionType = GraphQL::ObjectType.define do
  name 'Discussion'
  description 'A forum discussion'

  field :id, !types.ID
  field :title, !types.String
  field :created_at, !types.String
  field :updated_at, !types.String
  field :commented_at, !types.String

  field :user, !UserType
  field :comments, types[!CommentType]
end
