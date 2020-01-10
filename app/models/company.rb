class Company < ApplicationRecord
  NAME_WHEN_NOT_SETUP = :name_when_not_setup
  FIELDS = %i[
    name
  ].freeze

  has_many :company_users, dependent: :destroy
  # note there is users.company_id needed for current company
  has_many :users, through: :company_users
end
