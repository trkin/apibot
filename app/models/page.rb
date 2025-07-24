class Page < ApplicationRecord
  include ErrorLog
  FIELDS = %i[url content data error_log].freeze
  serialize :data, Hash
  belongs_to :run

  validates :url, presence: true
end
