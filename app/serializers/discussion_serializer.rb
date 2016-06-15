class DiscussionSerializer < ActiveModel::Serializer
  attributes :id, :title, :hits, :comments, :commented_at
end
