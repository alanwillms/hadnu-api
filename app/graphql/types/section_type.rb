SectionType = GraphQL::ObjectType.define do
  name 'Section'
  description 'A publication section'
  field :id, !types.ID
  field :created_at, !types.String
  field :updated_at, types.String
  field :published_at, types.String
  field :title, !types.String
  field :seo_description, types.String
  field :seo_keywords, types.String
  field :text, types.String
  field :source, types.String
  field :hits, !types.Int
  field :position, !types.Int

  field :banner_url, types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        return obj.banner.url(:card) if obj.banner.exists?
        obj.publication.banner.url(:card) if obj.publication.banner.exists?
      end
    )
  end

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.title}")
      end
    )
  end

  field :has_text, !types.Boolean do
    resolve(
      lambda do |obj, _args, _ctx|
        obj.text.to_s.strip.gsub(/\s/, '') != ''
      end
    )
  end

  field :parent_slug, types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        return nil unless obj.parent
        ActiveSupport::Inflector.parameterize(
          "#{obj.parent.id}-#{obj.parent.title}"
        )
      end
    )
  end

  field :previous, SectionType
  field :next, SectionType
  field :parent, SectionType
  field :root, SectionType
  field :publication, !PublicationType
  field :user, UserType
end
