class Comment < ApplicationRecord
  include PgSearch
  multisearchable against: [:plain_comment]

  belongs_to :discussion
  belongs_to :user

  after_save :update_discussion_comments_count
  after_save :update_subject_comments_count
  after_save :update_user_comments_count
  after_save :update_user_commented_discussions_count

  validates :user, presence: true
  validates :discussion, presence: true
  validates :comment,
            presence: true,
            length: { maximum: 8000 },
            uniqueness: { case_sensitive: false, scope: :discussion_id }

  def self.old_first
    order('created_at asc')
  end

  def plain_comment
    ActionController::Base.helpers.strip_tags(comment)
  end

  private

  def update_discussion_comments_count
    Discussion.unscoped.where(id: discussion.id).update_all("comments_count = (
      SELECT COUNT(1)
      FROM comments
      WHERE comments.discussion_id = discussions.id
    )")
  end

  def update_subject_comments_count
    Subject.unscoped.where(id: discussion.subject.id).update_all("comments_count = (
      SELECT COUNT(1)
      FROM comments
      JOIN discussions ON discussions.subject_id = subjects.id
      WHERE comments.discussion_id = discussions.id
    )")
  end

  def update_user_comments_count
    User.unscoped.where(id: user.id).update_all("comments_count = (
      SELECT COUNT(1)
      FROM comments
      WHERE comments.user_id = users.id
    )")
  end

  def update_user_commented_discussions_count
    User.unscoped.where(id: user.id).update_all("commented_discussions_count = (
      SELECT COUNT(DISTINCT discussion_id)
      FROM comments
      WHERE comments.user_id = users.id
    )")
  end
end
