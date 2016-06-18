class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true
  validates :discussion, presence: true

  def self.old_first
    order('created_at asc')
  end
end
