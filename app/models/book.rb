class Book < ApplicationRecord
  FIELDS = %i[title description price no_of_likes published_at].freeze
end
