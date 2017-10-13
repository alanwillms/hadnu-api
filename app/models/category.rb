class Category < ApplicationRecord
  has_and_belongs_to_many :publications
  has_attached_file :banner,
                    styles: { card: '630x354#' },
                    default_url: '/images/:style/missing.png',
                    convert_options: {
                      card: '-quality 85 -strip'
                    }

  validates :name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :hits,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :banner, less_than: 2.megabytes

  def slug
    ActiveSupport::Inflector.parameterize("#{id}-#{name}")
  end
end
