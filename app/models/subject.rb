class Subject < ApplicationRecord
  COLOR_FORMAT = /\A([A-Fa-f0-9]{6})\z/i

  has_many :discussions

  validates :name, presence: true, uniqueness: true
  validates :label_text_color, presence: true, format: { with: COLOR_FORMAT }
  validates :label_background_color,
            presence: true,
            uniqueness: true,
            format: { with: COLOR_FORMAT }
end
