CategoryType = GraphQL::ObjectType.define do
  name 'Category'
  description 'A publication category'
  field :id, !types.ID, 'Unique ID'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, !types.String, 'Last update timestamp'
  field :name, !types.String, 'Name'
  field :hits, !types.Int, 'Hits counter'
  field :description, types.String, 'Short description'
  field :slug, !types.String, 'Unique slug'

  field :banner_url do
    type types.String
    description 'Banner URL'
    argument :size, types.String, 'Image size: "card"'
    resolve(
      lambda do |object, arguments, _context|
        size = arguments && arguments[:size] ? arguments[:size].to_sym : nil
        object.banner.url(size) if object.banner.exists?
      end
    )
  end

  field :publications, types[!PublicationType], 'Its available publications'
end
