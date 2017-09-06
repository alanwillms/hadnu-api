DiscussionType = GraphQL::ObjectType.define do
  name 'Discussion'
  description 'A forum discussion'

  field :id, !types.ID
  field :title, !types.String
  field :created_at, !types.String
  field :updated_at, !types.String
  field :commented_at, !types.String
  field :hits, !types.Int
  field :comments_count, !types.Int
  field :closed, !types.Boolean
  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.title}")
      end
    )
  end

  field :subject, !SubjectType
  field :user, !UserType
  field :last_user, UserType
  field :comments, types[!CommentType]
end
