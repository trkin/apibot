class Inspect < ApplicationRecord
  FIELDS = %i[name target regexp].freeze
  belongs_to :bot

  validates :name, :target, presence: true
end
