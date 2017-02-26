class UpdateDiscussionService
  attr_reader :discussion

  def initialize(discussion, params)
    @comment_body = params.delete(:comment)
    @params = params
    @discussion = discussion
  end

  def save
    save!
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def save!
    Discussion.transaction do
      discussion.update_attributes! @params
      comment.update_attributes!({ comment: @comment_body })
    end
  end

  def errors
    errors = ActiveModel::Errors.new(self)
    if discussion.errors
      discussion.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    if comment.errors
      comment.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    errors
  end

  private

  def comment
    @comment ||= discussion.comments.old_first.first
  end
end
