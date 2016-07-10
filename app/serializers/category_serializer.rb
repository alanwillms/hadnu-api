class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :banner_url

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end
end
