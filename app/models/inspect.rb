class Inspect < ApplicationRecord
  FIELDS = %i[name target].freeze
  belongs_to :bot

  validates :name, :target, presence: true
end
