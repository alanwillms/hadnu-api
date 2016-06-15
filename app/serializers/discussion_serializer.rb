class DiscussionSerializer < ActiveModel::Serializer
  attributes :id, :title, :hits, :comments, :commented_at
  belongs_to :user
  belongs_to :last_user
end
