SubjectType = GraphQL::ObjectType.define do
  name 'Subject'
  description 'A forum subject'

  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, !types.String, 'Last update timestamp'
  field :name, !types.String, 'Subject name'
  field :label_background_color, !types.String, 'Label background color'
  field :label_text_color, !types.String, 'Label text color'
  field :discussions_count, !types.Int, 'Number of discussions on it'
  field :comments_count, !types.Int, 'Number of comments on discussons on it'

  field :discussions, types[!DiscussionType], 'Discussions on it'
end
