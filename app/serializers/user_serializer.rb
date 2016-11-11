require 'digest/md5'

class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :created_at, :comments_counter, :slug,
             :created_discussions_counter, :commented_discussions_counter,
             :photo_url, :photo_mini_url, :photo_thumb_url

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.login}")
  end

  def comments_counter
    object.comments.count
  end

  def created_discussions_counter
    object.discussions.count
  end

  def commented_discussions_counter
    Discussion.includes('comments').where(comments: { user_id: object.id }).count
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
