DiscussionType = GraphQL::ObjectType.define do
  name 'Discussion'
  description 'A forum discussion'

  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :title, !types.String, 'Discussion title'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, !types.String, 'Last update timestamp'
  field :commented_at, !types.String, 'Its last comment timestamp'
  field :hits, !types.Int, 'Hits counter'
  field :comments_count, !types.Int, 'Number of comments on it'
  field :closed, !types.Boolean, 'If it is closed for new comments'

  field :subject, !SubjectType, 'Subject to which it belongs'
  field :user, !UserType, 'User who started the discussion'
  field :last_user, UserType, 'Last user who commented on it'
  field :comments, types[!CommentType], 'Its comments'
end
