class Discussion < ApplicationRecord
  belongs_to :subject
  belongs_to :user
  belongs_to :last_user, class_name: "User"
  has_many :comments

  validates :title, presence: true
  validates :subject, presence: true

  def self.recent_first
    order('commented_at desc')
  end
end
