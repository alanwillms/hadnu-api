class CommentForm
  attr_reader :comment

  def initialize(discussion, user, params)
    @comment = discussion.comments.new(params)
    @comment.user = user
  end

  def save
    save!
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def save!
    check_if_user_waited_one_minute
    save_comment_and_update_discussion
  end

  def errors
    comment.errors
  end

  private

  def save_comment_and_update_discussion
    Comment.transaction do
      comment.save!
      comment.discussion.last_user = comment.user
      comment.discussion.commented_at = comment.created_at
      comment.discussion.comments_counter = comment.discussion.comments.count
      comment.discussion.save!
    end
  end

  def check_if_user_waited_one_minute
    if commented_more_recently_than_one_minute?
      message = I18n.t('activerecord.errors.messages.wait_one_minute')
      comment.errors.add(:comment, message)
      raise ActiveRecord::RecordInvalid
    end
  end

  def commented_more_recently_than_one_minute?
    Comment
      .where(user_id: comment.user.id)
      .where('created_at > ?', 1.minute.ago)
      .count > 0
  end
end
