CommentType = GraphQL::ObjectType.define do
  name 'Comment'
  description 'A discussion comment'
  field :id, !types.ID, 'Unique ID'
  field :comment, !types.String, 'Comment text'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'

  field :user, !UserType, 'User who created the record'
  field :discussion, !DiscussionType, 'Discussion to which it belongs'
end
