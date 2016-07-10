class Publications::ShowSerializer < PublicationSerializer
  attributes :original_title, :hits, :copyright_notice, :pdf_url,
             :root_section_id, :related

  has_many :authors
  has_many :sections

  def root_section_id
    object.root_section.id if object.root_section
  end

  def pdf_url
    object.pdf.url if object.pdf.exists?
  end

  def related
    scope = PublicationPolicy::Scope.new(current_user, Publication).resolve
    scope.random_order.limit(10).map do |publication|
      PublicationSerializer.new(publication)
    end
  end
end
