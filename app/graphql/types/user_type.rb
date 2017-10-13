UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'An user'

  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :login, !types.String, 'Unique login name'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'
  field :last_login_at, types.String, 'Last login timestamp'
  field :comments_count, !types.Int, 'Number of comments written by the user'
  field(
    :discussions_count,
    !types.Int,
    'Number of discussions started by the user'
  )
  field(
    :commented_discussions_count,
    !types.Int,
    'Number of discussions commented by the user'
  )
  field :comments, types[!CommentType], 'Comments written by the user'

  field :photo_url do
    type types.String
    description 'Photo URL'
    argument :size, types.String, 'Image size: "card", "mini" or "thumb"'
    resolve(
      lambda do |object, arguments, _context|
        size = arguments && arguments[:size] ? arguments[:size].to_sym : nil
        object.photo.url(size) if object.photo.exists?
      end
    )
  end
end
