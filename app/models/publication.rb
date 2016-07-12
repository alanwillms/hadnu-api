class Publication < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :authors, join_table: :authors_pseudonyms_publications
  has_and_belongs_to_many :pseudonyms,
                          join_table: :authors_pseudonyms_publications
  has_and_belongs_to_many :categories
  has_many :sections
  has_attached_file :banner,
                    styles: { card: '630x354#' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :pdf

  validates :user, presence: true
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :original_title, length: { maximum: 255 }
  validates :copyright_notice, length: { maximum: 1024 }
  validates :description, length: { maximum: 4000 }
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :pdf, content_type: 'application/pdf'
  validates_attachment_size :banner, less_than: 2.megabytes
  validates_attachment_size :pdf, less_than: 30.megabytes
  validates :hits,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
