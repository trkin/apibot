class Inspect < ApplicationRecord
  FIELDS = %i[name target target_attribute ignore_error_when_element_not_found regexp transformations].freeze
  acts_as_list scope: :bot
  TRANSFORMATIONS = %w[titleize upcase downcase to_lat to_cyr slugify].freeze
  KEYS_KEY = '[".keys"]'
  belongs_to :bot

  validates :name, presence: true, uniqueness: { scope: :bot_id }
  validates :target, presence: true
end
