CategoryType = GraphQL::ObjectType.define do
  name 'Category'
  description 'A publication category'
  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, !types.String
  field :name, !types.String
  field :hits, !types.Int
  field :description, types.String

  field :banner_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.banner.url(:card) if obj.banner.exists? }
  end

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.name}")
      end
    )
  end

  field :publications, types[!PublicationType]
end
