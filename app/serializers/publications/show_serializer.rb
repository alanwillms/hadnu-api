class Publications::ShowSerializer < PublicationSerializer
  attributes :original_title, :hits, :copyright_notice, :pdf_url,
    :root_section_id, :related

  has_many :authors
  has_many :sections

  def root_section_id
    object.root_section.id if object.root_section
  end

  def pdf_url
    publication_pdf_url object if object.pdf_file
  end

  def related
    PublicationPolicy::Scope.new(current_user, Publication).resolve.order('RANDOM()').limit(10).map do |publication|
      PublicationSerializer.new(publication)
    end
  end
end
