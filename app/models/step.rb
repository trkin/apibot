class Step < ApplicationRecord
  FIELDS = %i[position action selector_type locator filters].freeze

  serialize :filters, Hash

  belongs_to :bot
  acts_as_list scope: :bot, column: :position

  enum action: (StepService::ONE_TIME_ACTIONS + StepService::LOOPED_ACTIONS).each_with_object({}) { |k, o| o[k] = k.to_s }

  validates :action, :locator, presence: true
end
