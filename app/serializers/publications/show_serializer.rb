class Publications::ShowSerializer < PublicationSerializer
  attributes :original_title, :hits, :copyright_notice, :pdf_url,
             :root_section_id, :related, :featured, :blocked, :published,
             :signed_reader_only

  has_many :authors
  has_many :sections
  has_many :categories
  has_many :pseudonyms

  def root_section_id
    object.root_section.id if object.root_section
  end

  def pdf_url
    object.pdf.url if object.pdf.exists?
  end

  def related
    PublicationPolicy::Scope
      .new(current_user, Publication)
      .resolve
      .where('id <> ?', object.id)
      .random_order
      .limit(6)
      .map do |related|
        PublicationSerializer.new(related)
      end
  end
end
