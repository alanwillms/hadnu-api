class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :slug, :pen_name, :real_name, :photo_url, :photo_thumb_url

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.pen_name}")
  end

  def photo_thumb_url
    object.photo.url(:thumb) if object.photo.exists?
  end

  def photo_url
    object.photo.url(:card) if object.photo.exists?
  end
end
