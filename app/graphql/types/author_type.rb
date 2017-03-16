# frozen_string_literal: true

AuthorType = GraphQL::ObjectType.define do
  name 'Author'
  description 'A publication author'
  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'
  field :born_on, types.String, 'Date at which was born'
  field :passed_away_on, types.String, 'Date at which died'
  field :pen_name, !types.String, 'Main pseudonym or pen name'
  field :real_name, types.String, 'Full real name'
  field :description, types.String, 'Short biography'

  field :user, !UserType, 'User who created the record'
  field :pseudonyms, types[!PseudonymType], 'Its available pseudonyms'
  field :publications, types[!PublicationType], 'Its available publications'

  field :photo_url do
    type types.String
    description 'Photo URL'
    argument :size, types.String, 'Image size: "card" or "thumb"'
    resolve(
      lambda do |object, arguments, _context|
        size = arguments && arguments[:size] ? arguments[:size].to_sym : nil
        object.photo.url(size) if object.photo.exists?
      end
    )
  end
end
