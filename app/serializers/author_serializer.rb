class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :pen_name, :photo_url, :photo_thumb_url

  def photo_thumb_url
    object.photo.url(:thumb) if object.photo.exists?
  end

  def photo_url
    object.photo.url(:card) if object.photo.exists?
  end
end
