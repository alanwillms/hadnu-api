CreateCommentMutation = GraphQL::Relay::Mutation.define do
  name 'CreateComment'

  input_field :discussion_id, !types.ID
  input_field :user_id, !types.ID
  input_field :comment, !types.String

  return_field :discussion, DiscussionType
  return_field :comment, CommentType

  resolve -> (object, inputs, context) {
    discussion = Discussion.find(inputs[:discussion_id])
    comment = discussion.comments.create!({
      user_id: inputs[:user_id],
      comment: inputs[:comment]
    })

    {
      comment: comment,
      discussion: discussion,
    }
  }
end
