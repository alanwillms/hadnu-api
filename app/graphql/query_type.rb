QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :comments do
    type types[CommentType]
    description 'All comments'
    resolve -> (object, arguments, context) { Comment.all }
  end

  field :discussions do
    type types[DiscussionType]
    description 'All discussions'
    argument :sort, types.String
    resolve -> (object, arguments, context) {
      if arguments[:sort]
        Discussion.order(arguments[:sort])
      else
        Discussion.all
      end
    }
  end

  field :users do
    type types[UserType]
    description 'All users'
    resolve -> (object, arguments, context) { User.all }
  end

  field :discussion do
    type DiscussionType
    description 'The discussion associated with a given ID'
    argument :id, !types.ID
    resolve -> (object, arguments, context) { Discussion.find(arguments[:id]) }
  end

  field :user do
    type UserType
    description 'The user associated with a given ID'
    argument :id, !types.ID
    resolve -> (object, arguments, context) { User.find(arguments[:id]) }
  end
end
