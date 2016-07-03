class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :banner_url, :created_at

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end
end
