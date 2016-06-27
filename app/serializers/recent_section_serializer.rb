class RecentSectionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :seo_description, :published_at, :has_parent_section
  belongs_to :publication

  def has_parent_section
    object.parent_id != nil
  end
end
