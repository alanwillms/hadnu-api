class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :parent_id, :position, :has_text

  def has_text
    object.text.to_s.strip != ''
  end
end
