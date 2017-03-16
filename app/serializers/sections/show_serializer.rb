class Sections::ShowSerializer < SectionSerializer
  include Rails.application.routes.url_helpers

  attributes :text, :seo_keywords, :seo_description, :published_at, :next,
             :previous, :source

  def previous
    object.previous ? SectionSerializer.new(object.previous) : nil
  end

  def next
    object.next ? SectionSerializer.new(object.next) : nil
  end
end
