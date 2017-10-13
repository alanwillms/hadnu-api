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

  field :paginated_discussions, function: FindAllPaginated.new(
    model_class: Discussion,
    items_key: :discussions,
    refine_query: proc do |query, _object, arguments, context|
      if arguments[:subject_slug]
        context[:pundit].authorize Subject, :index?
        subject = Subject.find(arguments[:subject_slug])
        query = query.where(subject_id: subject.id)
      end
      query.recent_first
    end
  ) do
    type create_pagination_type(DiscussionType, :discussions)
    description 'Paginated discussions'
    argument :subject_slug, types.String, 'Filter by subject'
  end

  field :paginated_comments, function: FindAllPaginated.new(
    model_class: Comment,
    items_key: :comments,
    refine_query: proc do |query, _object, arguments, context|
      context[:pundit].authorize Discussion, :index?
      discussion = Discussion.find(arguments[:discussion_slug])
      query.where(discussion_id: discussion.id).old_first
    end
  ) do
    type create_pagination_type(CommentType, :comments)
    description 'Paginated comments'
    argument :discussion_slug, !types.String, 'Discussion to which these comments belong'
  end

  field :paginated_publications, function: FindAllPaginated.new(
    model_class: Publication,
    items_key: :publications,
    refine_query: proc { |query| query.recent_first }
  ) do
    type create_pagination_type(PublicationType, :publications)
    description 'Paginated publications'
  end

  field :authors, function: FindAll.new(
    model_class: Author,
    refine_query: proc { |query| query.order(:pen_name) }
  ) do
    type types[AuthorType]
    description 'All publication authors'
  end

  field :categories, function: FindAll.new(
    model_class: Category,
    refine_query: proc { |query| query.order(:name) }
  ) do
    type types[CategoryType]
    description 'All publication categories'
  end

  field :pseudonyms, function: FindAll.new(
    model_class: Pseudonym,
    refine_query: proc { |query| query.order(:name) }
  ) do
    type types[PseudonymType]
    description 'All pseudonyms'
  end

  field :subjects, function: FindAll.new(
    model_class: Subject,
    refine_query: proc { |query| query.order(:name) }
  ) do
    type types[SubjectType]
    description 'All forum subjects'
  end

  field :author, function: FindBySlug.new(Author) do
    type AuthorType
    description 'The author associated with a given slug'
  end

  field :category, function: FindBySlug.new(Category) do
    type CategoryType
    description 'The category associated with a given slug'
  end

  field :publication, function: FindBySlug.new(Publication) do
    type PublicationType
    description 'The publication associated with a given slug'
  end

  field :subject, function: FindBySlug.new(Subject) do
    type SubjectType
    description 'The subject associated with a given slug'
  end

  field :discussion, function: FindBySlug.new(Discussion) do
    type DiscussionType
    description 'The discussion associated with a given slug'
  end

  field :user, function: FindBySlug.new(User) do
    type UserType
    description 'The user associated with a given slug'
  end
end
