class Trace < ApplicationRecord
  FIELDS = %i[name config].freeze
  CONFIG_BOOLEAN_KEYS = %i[send_email_for_new_records]

  belongs_to :bot
  has_many :inspect_traces, dependent: :destroy
  accepts_nested_attributes_for :inspect_traces
  has_many :inspects, through: :inspect_traces

  validates :name, presence: true
end
