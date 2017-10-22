class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :created_at, :comments_counter, :slug,
             :created_discussions_counter, :commented_discussions_counter,
             :photo_url, :photo_mini_url, :photo_thumb_url, :disabled

  def slug
    return "#{object.id}-anonimo" if object.blocked
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.login}")
  end

  def login
    return "Anônimo #{object.id}" if object.blocked
    object.login
  end

  def disabled
    object.blocked
  end

  def comments_counter
    object.comments_count
  end

  def created_discussions_counter
    object.discussions_count
  end

  def commented_discussions_counter
    object.commented_discussions_count
  end

  def photo_mini_url
    object.photo.url(:mini) if object.photo.exists?
  end

  def photo_thumb_url
    object.photo.url(:thumb) if object.photo.exists?
  end

  def photo_url
    object.photo.url(:profile) if object.photo.exists?
  end
end
