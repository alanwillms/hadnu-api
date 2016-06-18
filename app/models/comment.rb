class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  def self.old_first
    order('created_at asc')
  end
end
