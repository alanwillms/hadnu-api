PublicationType = GraphQL::ObjectType.define do
  name 'Publication'
  description 'A publication: a book, an essay, a letter, etc.'
  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, types.String
  field :title, !types.String
  field :original_title, types.String
  field :description, types.String
  field :blocked, !types.Boolean
  field :blocked, !types.Boolean
  field :signed_reader_only, !types.Boolean
  field :featured, !types.Boolean
  field :hits, !types.Int
  field :copyright_notice, types.String

  field :banner_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.banner.url(:card) if obj.banner.exists? }
  end

  field :facebook_preview_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.banner.url(:facebook) if obj.banner.exists? }
  end

  field :google_preview_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.banner.url(:google) if obj.banner.exists? }
  end

  field :twitter_preview_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.banner.url(:twitter) if obj.banner.exists? }
  end

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.title}")
      end
    )
  end

  field :root_section_slug, types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        return nil unless obj.root_section
        ActiveSupport::Inflector.parameterize(
          "#{obj.root_section.id}-#{obj.root_section.title}"
        )
      end
    )
  end

  field :downloadable, !types.Boolean do
    resolve(
      lambda do |obj, _args, _ctx|
        obj.pdf.exists?
      end
    )
  end

  field :related, types[!PublicationType] do
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

  field :authors, types[!AuthorType]
  field :categories, types[!CategoryType]
  field :pseudonyms, types[!PseudonymType]
  field :sections, types[!SectionType]
  field :user, UserType
end
