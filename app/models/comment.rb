class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :user, presence: true
  validates :discussion, presence: true
  validates :comment,
            presence: true,
            length: { maximum: 8000 },
            uniqueness: { case_sensitive: false, scope: :discussion_id }

  def self.old_first
    order('created_at asc')
  end
end
