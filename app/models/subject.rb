class Subject < ApplicationRecord
  COLOR_FORMAT = /\A([A-Fa-f0-9]{6})\z/i

  has_many :discussions
  has_many :comments, through: :discussions

  validates :name, presence: true, uniqueness: true
  validates :label_text_color, presence: true, format: { with: COLOR_FORMAT }
  validates :label_background_color,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: COLOR_FORMAT }
  validates :comments_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :discussions_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
