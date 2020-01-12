class Step < ApplicationRecord
  FIELDS = %i[position action what with].freeze
  ACTIONS = [
    CLICK_ON = :click_on,
    FILL_IN = :fill_in,
    FIND_CSS_SELECTOR = :find_css_selector,
  ].freeze

  belongs_to :bot
  acts_as_list scope: :bot, column: :position

  enum action: ACTIONS.each_with_object({}) { |k, o| o[k] = k.to_s }

  validates :action, presence: true
end
