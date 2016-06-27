class PublicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :banner_url, :created_at

  def banner_url
    publication_banner_url object if object.banner_file
  end
end
