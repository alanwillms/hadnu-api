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
    text = object.text
    if text
      base_url = publication_section_url(object.publication, object) + '/images/'
      text = text.gsub('<livrourl>/', base_url)
      text = text.gsub('<livrourl>', base_url)
      text = text.gsub(/\/library\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\//, base_url)
      text = text.gsub(/http\:\/\/hadnu\.org\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\//, base_url)
    end
    text
  end
end
