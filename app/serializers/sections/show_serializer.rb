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

  def text
    return nil unless object.text
    text = object.text
    text_replacements.each { |from, to| text = text.gsub(from, to) }
    text
  end

  private

  def text_replacements
    {
      'images/symbols/' => 'static/images/symbols/',
      'images/layout/' => 'static/images/layout/',
      '<livrourl>/' => base_url,
      '<livrourl>' => base_url,
      /\/library\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
      /http\:\/\/hadnu\.org\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
      /\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
      %r{http\://hadnu.org/sections-images/view\?section\_id\=\d+\&amp\;file\=} => base_url
    }
  end

  def base_url
    @base_url ||= publication_section_url(object.publication, object) + '/images/'
  end
end
