class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :seo_keywords, :seo_description, :position, :published_at
end
