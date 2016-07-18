class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :description, :banner_url, :created_at

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end
end
