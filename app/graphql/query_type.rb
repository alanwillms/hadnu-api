require 'ostruct'

def create_pagination_type(model_class, items_field)
  GraphQL::ObjectType.define do
    name("Paginated#{model_class.name}")
    description("#{items_field.capitalize} pagination")
    field items_field, types[model_class]
    field :pagination, PaginationType
  end
end

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

  field :paginated_discussions do
    type create_pagination_type(DiscussionType, :discussions)
    description 'Paginated discussions'
    argument :per, types.Int, 'Number of records per page'
    argument :page, types.Int, 'Number of current page'
    argument :subject_slug, types.String, 'Filter by subject'
    resolve(
      lambda do |_object, arguments, context|
        context[:pundit].authorize Discussion, :index?
        discussions = Discussion
        if arguments[:subject_slug]
          discussions = Subject.find(arguments[:subject_slug]).discussions
        end
        query = context[:pundit]
          .policy_scope(discussions)
          .recent_first
          .page(arguments[:page] || 1)
          .per(arguments[:per] || 20)
        OpenStruct.new(
          discussions: query,
          pagination: Pagination.new(query)
        )
      end
    )
  end

  field :categories do
    type types[CategoryType]
    description 'All publication categories'
    resolve(
      lambda do |_object, _arguments, context|
        context[:pundit].authorize Category, :index?
        context[:pundit].policy_scope(Category).order(:name)
      end
    )
  end

  field :category do
    type CategoryType
    description 'The category associated with a given slug'
    argument :slug, !types.String
    resolve(
      lambda do |_object, arguments, context|
        record = context[:pundit].policy_scope(Category).find(arguments[:slug])
        context[:pundit].authorize record, :show?
        record
      end
    )
  end

  field :paginated_comments do
    type create_pagination_type(CommentType, :comments)
    description 'Paginated comments'
    argument :per, types.Int, 'Number of records per page'
    argument :page, types.Int, 'Number of current page'
    argument :discussion_slug, !types.String, 'Discussion to which these comments belong'
    resolve(
      lambda do |_object, arguments, context|
        context[:pundit].authorize Comment, :index?
        comments = Discussion.find(arguments[:discussion_slug]).comments
        query = context[:pundit]
          .policy_scope(comments)
          .old_first
          .page(arguments[:page] || 1)
          .per(arguments[:per] || 20)
        OpenStruct.new(
          comments: query,
          pagination: Pagination.new(query)
        )
      end
    )
  end

  field :pseudonyms do
    type types[PseudonymType]
    description 'All pseudonyms'
    resolve ->(object, arguments, context) { Pseudonym.all }
  end

  field :paginated_publications do
    type create_pagination_type(PublicationType, :publications)
    description 'Paginated publications'
    argument :per, types.Int, 'Number of records per page'
    argument :page, types.Int, 'Number of current page'
    resolve(
      lambda do |_object, arguments, context|
        context[:pundit].authorize Publication, :index?
        publications = Publication
        query = context[:pundit]
          .policy_scope(publications)
          .recent_first
          .page(arguments[:page] || 1)
          .per(arguments[:per] || 20)
        OpenStruct.new(
          publications: query,
          pagination: Pagination.new(query)
        )
      end
    )
  end

  field :publication do
    type PublicationType
    description 'The publication associated with a given slug'
    argument :slug, !types.String
    resolve(
      lambda do |_object, arguments, context|
        record = context[:pundit].policy_scope(Publication).find(arguments[:slug])
        context[:pundit].authorize record, :show?
        record
      end
    )
  end

  field :subject do
    type SubjectType
    description 'The subject associated with a given slug'
    argument :slug, !types.String
    resolve(
      lambda do |_object, arguments, context|
        record = context[:pundit].policy_scope(Subject).find(arguments[:slug])
        context[:pundit].authorize record, :show?
        record
      end
    )
  end

  field :subjects do
    type types[SubjectType]
    description 'All forum subjects'
    resolve ->(object, arguments, context) { Subject.all }
  end

  field :discussion do
    type DiscussionType
    description 'The discussion associated with a given slug'
    argument :slug, !types.String
    resolve ->(object, arguments, context) { Discussion.find(arguments[:slug]) }
  end

  field :user do
    type UserType
    description 'The user associated with a given slug'
    argument :slug, !types.String
    argument :id, !types.ID
    resolve ->(object, arguments, context) { User.find(arguments[:slug]) }
  end
end
