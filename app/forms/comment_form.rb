class CommentForm
  attr_reader :comment

  def initialize(discussion, user, params)
    @comment = discussion.comments.new(params)
    @comment.user = user
  end

  def save
    save!
    true
  rescue ActiveRecord::RecordInvalid => exception
    false
  end

  def save!
    Comment.transaction do
      comment.save!
      comment.discussion.last_user = comment.user
      comment.discussion.commented_at = comment.created_at
      comment.discussion.comments_counter = comment.discussion.comments.count
      comment.discussion.save!
    end
  end

  def errors
    comment.errors
  end
end
