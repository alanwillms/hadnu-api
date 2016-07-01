class Sections::ShowSerializer < SectionSerializer
  attributes :text, :seo_keywords, :seo_description, :published_at, :next,
    :previous

  def previous
    object.previous ? SectionSerializer.new(object.previous) : nil
  end

  def next
    object.next ? SectionSerializer.new(object.next) : nil
  end
end
