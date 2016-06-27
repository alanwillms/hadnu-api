class RecentSectionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :seo_description, :published_at
  belongs_to :publication
end
