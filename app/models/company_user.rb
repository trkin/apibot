class CompanyUser < ApplicationRecord
  FIELDS = %i[position].freeze
  belongs_to :company
  belongs_to :user
  accepts_nested_attributes_for :user
  enum position: %i[admin regular].each_with_object({}) { |k, o| o[k] = k.to_s }
end
