class DiscussionSerializer < ActiveModel::Serializer
  attributes :id, :title, :hits, :comments_counter, :commented_at
  belongs_to :subject
  belongs_to :user
  belongs_to :last_user
end
