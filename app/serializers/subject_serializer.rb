class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :label_background_color, :label_text_color,
             :discussions_counter, :comments_counter

  def slug
    ActiveSupport::Inflector.parameterize("#{object.id}-#{object.name}")
  end

  def discussions_counter
    object.discussions.count
  end

  def comments_counter
    object.comments.count
  end
end
