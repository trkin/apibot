class Bot < ApplicationRecord
  FIELDS = %i[start_url name].freeze
  belongs_to :company

  has_many :inspects, dependent: :destroy
  has_many :steps, dependent: :destroy

  validates :start_url, presence: true
end
