class Publications::ShowSerializer < PublicationSerializer
  attributes :original_title, :hits, :copyright_notice, :pdf_url,
             :root_section_id

  has_many :authors
  has_many :sections
  has_many :categories

  def root_section_id
    object.root_section.id if object.root_section
  end

  def pdf_url
    object.pdf.url if object.pdf.exists?
  end
end
