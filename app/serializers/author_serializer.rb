class AuthorSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :pen_name, :photo_url

  def photo_url
    author_photo_url object if object.photo_file
  end
end
