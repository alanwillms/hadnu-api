class Section < ApplicationRecord
  belongs_to :publication
  belongs_to :user
  belongs_to :parent, optional: true, class_name: 'Section'
  belongs_to :root, optional: true, class_name: 'Section'
  has_many :children, class_name: 'Section', foreign_key: 'parent_id'

  validates :user, presence: true
  validates :publication, presence: true
  validates :title,
            presence: true,
            uniqueness: { scope: :publication_id },
            length: { maximum: 255 }
  validates :published_at, date: true, allow_nil: true
  validates :seo_description, length: { maximum: 255 }
  validates :seo_keywords, length: { maximum: 255 }
  validates :source, length: { maximum: 255 }
  validates :hits,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position,
            presence: true,
            uniqueness: { scope: [:parent_id, :publication_id] },
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def next
    # First child if any
    return children.order(:position).first if children.count > 0

    # Nil if there is no parent
    return nil unless parent

    # Sibling if any
    section = Section.find_by(parent_id: parent_id, position: position + 1)
    return section if section

    # Parent sibling if any
    Section.find_by(parent_id: parent.parent_id, position: parent.position + 1)
  end

  def previous
    # nil if there is no parent
    return nil unless parent

    # Sibling last descendant, if any, or sibling itself
    previous = Section.find_by(parent_id: parent_id, position: position - 1)

    if previous
      while previous.children.count > 0
        previous = previous.children.order(:position).last
      end
    end

    # Parent otherwise
    previous || parent
  end

  def self.recent
    Section.where.not(published_at: nil).order(published_at: :desc)
  end
end
