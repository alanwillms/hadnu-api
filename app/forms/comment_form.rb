class CommentForm
  def initialize(discussion, user, params)
    @comment = discussion.comments.new(params)
    @comment.user = user
  end

  def save
    @comment.save
  end

  def errors
    @comment.errors
  end
end
