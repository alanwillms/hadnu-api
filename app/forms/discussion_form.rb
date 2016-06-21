class DiscussionForm
  attr_reader :discussion

  def initialize(user, params)
    @comment_body = params.delete(:comment)

    @discussion = Discussion.new(params)
    @discussion.user = user
    @discussion.last_user = user
  end

  def save
    save!
    true
  rescue ActiveRecord::RecordInvalid => exception
    false
  end

  def save!
    Discussion.transaction do
      discussion.save!
      comment_form.save!
    end
  end

  def errors
    errors = ActiveModel::Errors.new(self)
    if discussion.errors
      discussion.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    if comment_form.errors
      comment_form.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    errors
  end

  private

  def comment_form
    @comment_form ||= CommentForm.new(discussion, discussion.user, {comment: @comment_body})
  end
end
