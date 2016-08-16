class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :description, :created_at, :banner_url,
             :facebook_preview_url, :google_preview_url, :twitter_preview_url

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end

  def banner_url
    object.banner.url(:card) if object.banner.exists?
  end

  def facebook_preview_url
    object.banner.url(:facebook) if object.banner.exists?
  end

  def google_preview_url
    object.banner.url(:google) if object.banner.exists?
  end

  def twitter_preview_url
    object.banner.url(:twitter) if object.banner.exists?
  end
end
