SectionType = GraphQL::ObjectType.define do
  name 'Section'
  description 'A publication section or chapter'

  field :id, !types.ID, 'Unique ID'
  field :slug, !types.String, 'Unique slug'
  field :created_at, !types.String, 'Creation timestamp'
  field :updated_at, types.String, 'Last update timestamp'
  field :published_at, types.String, 'Timestamp at which it is listed in news feed'
  field :title, !types.String, 'Section title'
  field :seo_description, types.String, 'Description to be read by SEO crawlers'
  field :seo_keywords, types.String, 'Keywords to be read by SEO crawlers'
  field :text, types.String, 'Contents of the chapter in HTML format'
  field :source, types.String, 'Source of this text and/or translation'
  field :hits, !types.Int, 'Hits counter'
  field :position, !types.Int, 'Position when listing all sections of its publication'

  field :previous, SectionType, 'Previous section in the same publication'
  field :next, SectionType, 'Next section in the same publication'
  field :parent, SectionType, 'Parent section in the same publication, not the same as the previous'
  field :root, SectionType, 'Root section or chapter of the publication to which it belongs'
  field :publication, !PublicationType, 'Publication to which it belongs'
  field :user, UserType, 'User who created the record'

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

  field :has_text, !types.Boolean, 'If it has text or not' do
    resolve(
      lambda do |obj, _args, _ctx|
        obj.text.to_s.strip.gsub(/\s/, '') != ''
      end
    )
  end
end
