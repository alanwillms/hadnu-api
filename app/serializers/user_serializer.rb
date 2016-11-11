require 'digest/md5'

class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :gravatar, :created_at, :comments_counter, :slug,
             :created_discussions_counter, :commented_discussions_counter

  def gravatar
    "//www.gravatar.com/avatar/" + Digest::MD5.hexdigest(object.email)
  end

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
end
