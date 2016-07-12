class Discussion < ApplicationRecord
  belongs_to :subject
  belongs_to :user
  belongs_to :last_user, class_name: 'User'
  has_many :comments

  validates :title,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :subject, presence: true
  validates :user, presence: true
  validates :last_user, presence: true
  validates :commented_at, presence: true
  validates :hits,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :comments_counter,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :closed, inclusion: { in: [true, false] }

  def self.recent_first
    order('commented_at desc')
  end
end
