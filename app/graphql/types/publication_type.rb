PublicationType = GraphQL::ObjectType.define do
  name 'Publication'
  description 'A publication: a book, an essay, a letter, etc.'
  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'
  field :title, !types.String, 'Work title'
  field :original_title, types.String, 'Work title in its original language'
  field :description, types.String, 'Short description'
  field :blocked, !types.Boolean, 'If it can only be accesed by admins'
  field :published, !types.Boolean, 'If it is a draft or is published in the website'
  field :signed_reader_only, !types.Boolean, 'If it can only be accesed by signed in users'
  field :featured, !types.Boolean, 'If it is featured in the home page'
  field :hits, !types.Int, 'Hits counter'
  field :copyright_notice, types.String, 'Information regarding this work copyrights'

  field :authors, types[!AuthorType], 'Its authors'
  field :categories, types[!CategoryType], 'Categories to which it belongs'
  field :pseudonyms, types[!PseudonymType], 'Pseudonyms of its authors used for writing this work'
  field :sections, types[!SectionType], 'Its sections or chapters'
  field :user, UserType, 'User who created the record'
  field :root_section, SectionType, 'First section or chapter'

  field :banner_url do
    type types.String
    description 'Banner URL'
    argument :size, types.String, 'Image size: "card", "facebook", "google", "twitter"'
    resolve(
      lambda do |object, arguments, _context|
        size = arguments && arguments[:size] ? arguments[:size].to_sym : nil
        object.banner.url(size) if object.banner.exists?
      end
    )
  end

  field :downloadable, !types.Boolean, 'If there is a PDF version to be downloaded' do
    resolve(
      lambda do |obj, _args, _ctx|
        obj.pdf.exists?
      end
    )
  end

  field :related, types[!PublicationType], 'Related publications' do
    resolve(
      lambda do |obj, _args, context|
        context[:pundit].authorize Publication, :index?
        context[:pundit].policy_scope(Publication)
          .where('id <> ?', obj.id)
          .random_order
          .limit(6)
      end
    )
  end
end
