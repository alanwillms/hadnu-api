class Sections::ShowSerializer < SectionSerializer
  include Rails.application.routes.url_helpers

  attributes :text, :seo_keywords, :seo_description, :published_at, :next,
             :previous

  def previous
    object.previous ? SectionSerializer.new(object.previous) : nil
  end

  def next
    object.next ? SectionSerializer.new(object.next) : nil
  end

  def text
    return nil unless object.text
    text = object.text
    base_url = publication_section_url(object.publication, object) + '/images/'
    text = text.gsub('images/symbols/', 'static/images/symbols/')
    text = text.gsub('images/layout/', 'static/images/layout/')
    text = text.gsub('<livrourl>/', base_url)
    text = text.gsub('<livrourl>', base_url)
    text = text.gsub(/\/library\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\//, base_url)
    text = text.gsub(/http\:\/\/hadnu\.org\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\//, base_url)
    text
  end
end
