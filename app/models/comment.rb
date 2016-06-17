class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  def self.recent_first
    order('created_at desc')
  end
end
