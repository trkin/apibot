class Inspect < ApplicationRecord
  FIELDS = %i[name target regexp value_target].freeze
  VALUE_TARGETS = %w[text href].freeze
  belongs_to :bot

  validates :name, :target, presence: true
end
