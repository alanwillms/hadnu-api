class DiscussionSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title, :hits, :comments_counter, :commented_at,
             :created_at, :closed
  belongs_to :subject
  belongs_to :user
  belongs_to :last_user

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.title}")
  end
end
