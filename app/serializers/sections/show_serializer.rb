class Sections::ShowSerializer < SectionSerializer
  attributes :text, :seo_keywords, :seo_description, :published_at, :next,
    :previous
end
