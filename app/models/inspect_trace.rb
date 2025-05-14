class InspectTrace < ApplicationRecord
  FIELDS = %i[inspect trace].freeze
  belongs_to :inspect
  belongs_to :trace
end
