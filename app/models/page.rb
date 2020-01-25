class Page < ApplicationRecord
  FIELDS = %i[url content data].freeze
  serialize :data, Hash
  belongs_to :run
end
