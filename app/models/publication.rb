class Publication < ApplicationRecord
  has_and_belongs_to_many :categories

  def self.recent_first
    order(created_at: :desc)
  end
end
