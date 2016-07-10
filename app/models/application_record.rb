class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random_order
    order('RANDOM()')
  end
end
