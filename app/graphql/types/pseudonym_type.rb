PseudonymType = GraphQL::ObjectType.define do
  name 'Pseudonym'
  description 'An author pseudonym'
  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, types.String
  field :name, !types.String

  field :author, !AuthorType
  field :user, !UserType
  field :publications, types[!PublicationType]
end
