class Author < ApplicationRecord
  has_and_belongs_to_many :publications, join_table: :authors_pseudonyms_publications

  def self.random_order
    order('RANDOM()')
  end
end
