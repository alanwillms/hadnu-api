class Section < ApplicationRecord
  belongs_to :publication

  def next
    Section.where(parent_id: parent_id, position: position + 1).first
  end

  def previous
    Section.where(parent_id: parent_id, position: position - 1).last
  end
end
