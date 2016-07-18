class SectionSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :parent_id, :position, :has_text

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end

  def has_text
    object.text.to_s.strip != ''
  end
end
