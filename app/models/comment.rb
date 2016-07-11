class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :user, presence: true
  validates :discussion, presence: true
  validates :comment,
            presence: true,
            length: { maximum: 8000 },
            uniqueness: { case_sensitive: false, scope: :discussion_id }
  validate :user_waits_before_commenting_again

  # @TODO Move to comment form and discussion form
  def user_waits_before_commenting_again
    # range = 1.minute.ago
    # if self.class.where(user_id: user_id).where('created_at > ?', range).count > 0
    #   message = I18n.t('activerecord.errors.messages.wait_one_minute')
    #   errors.add(:comment, message)
    # end
  end

  def self.old_first
    order('created_at asc')
  end
end
