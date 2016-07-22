class CategorySerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :description, :banner_url

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.name}")
  end

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end
end
