class Publication < ApplicationRecord
  has_and_belongs_to_many :authors, join_table: :authors_pseudonyms_publications
  has_and_belongs_to_many :categories
  has_many :sections
  has_attached_file :banner,
                    styles: { card: '630x354#' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :pdf

  validates :title, presence: true
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  def published_at
    root_section&.published_at || created_at
  end

  def root_section
    sections.where(parent_id: nil).first
  end

  def self.recent_first
    order(created_at: :desc)
  end

  def self.featured
    where(featured: true)
  end
end
