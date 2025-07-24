class Run < ApplicationRecord
  include ErrorLog
  FIELDS = %i[status log error_log finished_at].freeze
  STATUSES = [
    IN_QUEUE = :in_queue,
    IN_PROGRESS = :in_progress,
    FINISHED = :finished,
    FAILED = :failed,
    CANCELLED = :cancelled,
  ]

  has_many :pages, dependent: :destroy
  belongs_to :bot

  enum status: STATUSES.each_with_object({}) { |k, o| o[k] = k.to_s }

  def still_running?
    in_queue? | in_progress?
  end

  def generate_csv(selected_pages: nil)
    selected_pages ||= pages
    CSV.generate do |csv|
      not_shown_inspect_names = bot.inspects.select {|inspect| !inspect.shown_in_output}.map(&:name)
      csv << bot.inspects.map(&:name) - not_shown_inspect_names
      selected_pages.each do |page|
        csv << page.data.except(*not_shown_inspect_names).values
      end
    end
  end

  def generate_json(selected_pages: nil)
    selected_pages ||= pages
    result = selected_pages.map do |page|
      page.data
    end
    result.to_json
  end
end
