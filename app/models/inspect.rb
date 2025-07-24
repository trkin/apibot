class Inspect < ApplicationRecord
  FIELDS = %i[name target target_attribute ignore_error_when_element_not_found regexp transformations shown_in_output interpolation].freeze
  acts_as_list scope: :bot
  TRANSFORMATIONS = %w[titleize upcase downcase to_lat to_cyr slugify uniq uri_escape].freeze
  KEYS_KEY = [".keys"]
  belongs_to :bot
  has_many :inspect_traces, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :bot_id }
  validates :target, presence: true

  def hidden_or_ignored_html
    result = ""
    result += "hidden<br>" unless shown_in_output
    result += "<small>ignore error when not found</small>" if ignore_error_when_element_not_found

    result
  end
end
