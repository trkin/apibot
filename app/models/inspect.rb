class Inspect < ApplicationRecord
  FIELDS = %i[name target target_attribute regexp transformations].freeze
  TRANSFORMATIONS = %w[titleize upcase downcase to_lat to_cyr slugify].freeze
  KEYS_KEY = '[".keys"]'
  belongs_to :bot

  validates :name, presence: true, uniqueness: { scope: :bot_id }
  validates :target, presence: true
end
