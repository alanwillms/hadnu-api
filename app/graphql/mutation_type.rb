MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The root of all mutations'

  field :createComment, field: CreateCommentMutation.field
end
