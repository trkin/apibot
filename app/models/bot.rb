class Bot < ApplicationRecord
  FIELDS = %i[start_url name headless config].freeze
  CONFIG_BOOLEAN_KEYS = %i[create_screenshots include_page_url_in_data include_apibot_url_in_data]
  serialize :config, Hash

  belongs_to :company

  has_many :inspects, dependent: :destroy
  accepts_nested_attributes_for :inspects
  has_many :steps, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :steps
  has_many :runs, dependent: :destroy

  validates :start_url, presence: true, format: URI::regexp(%w[http https])

  def name_or_start_url
    if name.present?
      name
    else
      start_url
    end
  end

  def last_run
    runs.last
  end

  def last_page
    last_run.pages.last
  end

  def create_and_perform_run
    run = runs.create! status: Run::IN_QUEUE
    RunJob.perform_now run
  end
end
