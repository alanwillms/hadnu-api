class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :last_user, class_name: "User"

  def self.recent_first
    order('commented_at desc')
  end
end
