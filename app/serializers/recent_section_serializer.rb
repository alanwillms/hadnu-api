class RecentSectionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :slug, :title, :seo_description, :published_at,
             :has_parent_section, :banner_url
  belongs_to :publication

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end

  def has_parent_section
    !object.parent_id.nil?
  end

  def banner_url
    return object.banner.url(:card) if object.banner.exists?
    object.publication.banner.url(:card) if object.publication.banner.exists?
  end
end
