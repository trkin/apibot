class Step < ApplicationRecord
  FIELDS = %i[position action selector_type locator filters].freeze

  serialize :filters, Hash

  # https://github.com/rails/rails/issues/28761 accepts_nested_attributes_for
  # does not work when we use has_many :steps, -> { order ... error is 
  # bot must exists, so we use optional: true as a workaround
  belongs_to :bot, optional: true
  acts_as_list scope: :bot, column: :position

  enum action: (PageService::ONE_TIME_ACTIONS + PageService::LOOPED_ACTIONS).each_with_object({}) { |k, o| o[k.to_s] = k.to_s }

  validates :locator, presence: true, if: ->(step) { PageService::ACTIONS_THAT_DOES_NOT_NEED_LOCATOR.include? step.action }
end
