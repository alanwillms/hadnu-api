class CategorySerializer < ActiveModel::Serializer
  include ActionView::Helpers::AssetTagHelper

  attributes :id, :name, :description, :banner_url

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end
end
