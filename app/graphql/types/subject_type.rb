SubjectType = GraphQL::ObjectType.define do
  name 'Subject'
  description 'A forum subject'

  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, !types.String
  field :name, !types.String
  field :label_background_color, !types.String
  field :label_text_color, !types.String
  field :discussions_count, !types.Int
  field :comments_count, !types.Int

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.name}")
      end
    )
  end

  field :discussions, types[!DiscussionType]
end
