class CategorySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :banner_url

  def banner_url
    category_banner_url object
  end
end
