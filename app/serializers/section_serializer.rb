class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :parent_id, :position
end
