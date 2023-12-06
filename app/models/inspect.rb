class Inspect < ApplicationRecord
  FIELDS = %i[name target regexp value_target transformations].freeze
  VALUE_TARGETS = %w[text href].freeze
  TRANSFORMATIONS = %w[titleize upcase downcase].freeze
  belongs_to :bot

  validates :name, :target, presence: true
end
