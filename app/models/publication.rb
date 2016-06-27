class Publication < ApplicationRecord
  has_and_belongs_to_many :authors, join_table: :authors_pseudonyms_publications
  has_and_belongs_to_many :categories
  has_many :sections

  def root_section
    sections.where(parent_id: nil).first
  end

  def self.recent_first
    order(created_at: :desc)
  end
end
