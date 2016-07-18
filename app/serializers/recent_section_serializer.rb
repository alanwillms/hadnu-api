class RecentSectionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :slug, :title, :seo_description, :published_at,
             :has_parent_section
  belongs_to :publication

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end

  def has_parent_section
    !object.parent_id.nil?
  end
end
