class Discussion < ApplicationRecord
  belongs_to :subject
  belongs_to :user
  belongs_to :last_user, class_name: 'User'
  has_many :comments

  after_save :update_subject_discussions_count
  after_save :update_user_discussions_count

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
  validates :comments_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :closed, inclusion: { in: [true, false] }

  def hit!
    self.class.where(id: id).update_all('hits = hits + 1')
    self.hits += 1
    self
  end

  def self.recent_first
    order('commented_at desc')
  end

  def update_subject_discussions_count
    Subject.unscoped.where(id: subject.id).update_all("discussions_count = (
      SELECT COUNT(1)
      FROM discussions
      WHERE discussions.subject_id = subjects.id
    )")
  end

  def update_user_discussions_count
    User.unscoped.where(id: user.id).update_all("discussions_count = (
      SELECT COUNT(1)
      FROM discussions
      WHERE discussions.user_id = users.id
    )")
  end
end
