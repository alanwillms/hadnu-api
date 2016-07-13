class DiscussionForm
  attr_reader :discussion

  def initialize(user, params)
    @comment_body = params.delete(:comment)

    @discussion = Discussion.new(params)
    @discussion.user = user
    @discussion.last_user = user
    @discussion.commented_at = Time.now
  end

  def save
    save!
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def save!
    check_if_user_waited_15_minutes
    save_discussion_and_first_comment
  end

  def errors
    errors = ActiveModel::Errors.new(self)
    if discussion.errors
      discussion.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    if comment_form.errors
      comment_form.errors.each do |attribute, error|
        errors.add(attribute, error)
      end
    end
    errors
  end

  private

  def comment_form
    @comment_form ||= CommentForm.new(
      discussion,
      discussion.user,
      comment: @comment_body
    )
  end

  def save_discussion_and_first_comment
    Discussion.transaction do
      discussion.save!
      comment_form.save!
    end
  end

  def check_if_user_waited_15_minutes
    if created_discussion_more_recently_than_15_minutes?
      message = I18n.t('activerecord.errors.messages.wait_15_minutes')
      discussion.errors.add(:title, message)
      raise ActiveRecord::RecordInvalid
    end
  end

  def created_discussion_more_recently_than_15_minutes?
    Discussion
      .where(user_id: discussion.user.id)
      .where('created_at > ?', 15.minutes.ago)
      .count > 0
  end
end
