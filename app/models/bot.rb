class Bot < ApplicationRecord
  FIELDS = %i[start_url name headless config].freeze
  CONFIG_BOOLEAN_KEYS = %i[create_screenshots include_page_url_in_data include_apibot_url_in_data]

  belongs_to :company

  has_many :inspects, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :bot
  accepts_nested_attributes_for :inspects
  has_many :steps, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :bot
  accepts_nested_attributes_for :steps
  has_many :traces, dependent: :destroy
  accepts_nested_attributes_for :traces

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
    last_run.pages.order(updated_at: :asc).last
  end

  def create_and_perform_run
    run = runs.create! status: Run::IN_QUEUE
    RunJob.perform_now run
  end

  def duplicate!
    new_bot = dup
    steps.each do |step|
      new_bot.steps.build step.dup.attributes
    end
    inspects.each do |inspect|
      new_bot.inspects.build inspect.dup.attributes
    end
    new_bot.runs.build last_run.dup.attributes
    new_bot.name += "(duplicated #{Time.zone.now}"
    new_bot.save!
    new_bot
  end
end
