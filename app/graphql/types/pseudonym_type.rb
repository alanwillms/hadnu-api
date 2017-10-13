PseudonymType = GraphQL::ObjectType.define do
  name 'Pseudonym'
  description 'An author pseudonym'
  field :id, !types.ID, 'Unique ID'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'
  field :name, !types.String, 'Pseudonym'

  field :author, !AuthorType, 'Author to which it belongs'
  field :user, !UserType, 'User who created the record'
  field :publications, types[!PublicationType], 'Its available publications'
end
