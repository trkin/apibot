class Bot < ApplicationRecord
  FIELDS = %i[start_url name engine].freeze
  belongs_to :company

  has_many :inspects, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :runs, dependent: :destroy

  enum engine: %i[
    selenium_chrome
    selenium_chrome_headless
    mechanize
  ].each_with_object({}) { |k, o| o[k] = k.to_s }

  validates :start_url, presence: true, format: URI::regexp(%w[http https])

  def name_or_start_url
    if name.present?
      name
    else
      start_url
    end
  end
end
