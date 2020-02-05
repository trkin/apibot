class Page < ApplicationRecord
  FIELDS = %i[url content data error_log].freeze
  serialize :data, Hash
  belongs_to :run
end
