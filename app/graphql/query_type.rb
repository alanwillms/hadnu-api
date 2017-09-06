QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :author do
    type AuthorType
    description 'The author associated with a given slug'
    argument :slug, !types.String
    resolve(
      lambda do |_object, arguments, context|
        record = context[:pundit].policy_scope(Author).find(arguments[:slug])
        context[:pundit].authorize record, :show?
        record
      end
    )
  end

  field :authors do
    type types[AuthorType]
    description 'All publication authors'
    resolve(
      lambda do |_object, _arguments, context|
        context[:pundit].authorize Author, :index?
        context[:pundit].policy_scope(Author).order(:pen_name)
      end
    )
  end

  field :categories do
    type types[CategoryType]
    description 'All publication categories'
    resolve ->(object, arguments, context) { Category.all }
  end

  field :comments do
    type types[CommentType]
    description 'All forum comments'
    resolve ->(object, arguments, context) { Comment.all }
  end

  field :discussions do
    type types[DiscussionType]
    description 'All forum discussions'
    argument :sort, types.String
    resolve ->(object, arguments, context) {
      if arguments[:sort]
        Discussion.order(arguments[:sort])
      else
        Discussion.all
      end
    }
  end

  field :pseudonyms do
    type types[PseudonymType]
    description 'All pseudonyms'
    resolve ->(object, arguments, context) { Pseudonym.all }
  end

  field :publications do
    type types[PublicationType]
    description 'All publications'
    resolve ->(object, arguments, context) { Publication.all }
  end

  field :sections do
    type types[SectionType]
    description 'All publication sections'
    resolve ->(object, arguments, context) { Section.all }
  end

  field :subjects do
    type types[SubjectType]
    description 'All forum subjects'
    resolve ->(object, arguments, context) { Subject.all }
  end

  # field :users do
  #   type types[UserType]
  #   description 'All users'
  #   resolve ->(object, arguments, context) { User.all }
  # end

  field :discussion do
    type DiscussionType
    description 'The discussion associated with a given ID'
    argument :id, !types.ID
    resolve ->(object, arguments, context) { Discussion.find(arguments[:id]) }
  end

  field :user do
    type UserType
    description 'The user associated with a given ID'
    argument :id, !types.ID
    resolve ->(object, arguments, context) { User.find(arguments[:id]) }
  end
end
