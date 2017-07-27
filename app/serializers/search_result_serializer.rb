class SearchResultSerializer < ActiveModel::Serializer
  attributes :id, :slug, :type, :highlight, :title, :parent_slug, :parent_title

  def id
    object.searchable_id
  end

  def slug
    if object.searchable.is_a? Section
      sluggable = object.searchable
      ActiveSupport::Inflector.parameterize("#{sluggable.id}-#{sluggable.title}")
    end
  end

  def parent_slug
    if object.searchable.is_a? Section
      sluggable = object.searchable.publication
      ActiveSupport::Inflector.parameterize("#{sluggable.id}-#{sluggable.title}")
    elsif object.searchable.is_a? Comment
      sluggable = object.searchable.discussion
      ActiveSupport::Inflector.parameterize("#{sluggable.id}-#{sluggable.title}")
    end
  end

  def type
    object.searchable_type
  end

  def highlight
    object.pg_search_highlight
  end

  def title
    if object.searchable.is_a? Section
      object.searchable.title
    end
  end

  def parent_title
    if object.searchable.is_a? Section
      object.searchable.publication.title
    elsif object.searchable.is_a? Comment
      object.searchable.discussion.title
    end
  end
end
