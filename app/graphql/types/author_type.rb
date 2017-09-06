AuthorType = GraphQL::ObjectType.define do
  name 'Author'
  description 'A publication author'
  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, types.String
  field :born_on, types.String
  field :passed_away_on, types.String
  field :pen_name, !types.String
  field :real_name, types.String
  field :description, types.String
  field :photo_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.photo.url(:card) if obj.photo.exists? }
  end

  field :photo_thumb_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.photo.url(:thumb) if obj.photo.exists? }
  end

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.pen_name}")
      end
    )
  end

  field :user, !UserType
  field :pseudonyms, types[!PseudonymType]
  field :publications, types[!PublicationType]
end
