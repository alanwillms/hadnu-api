class Section < ApplicationRecord
  belongs_to :publication
  belongs_to :parent, optional: true, class_name: 'Section'
  belongs_to :root, optional: true, class_name: 'Section'

  def next
    Section.where(parent_id: parent_id, position: position + 1).first
  end

  def previous
    Section.where(parent_id: parent_id, position: position - 1).last
  end

  def self.recent
    Section.where.not(published_at: nil).order(published_at: :desc)
  end
end
