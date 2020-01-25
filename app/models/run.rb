class Run < ApplicationRecord
  FIELDS = %i[status log finished_at].freeze
  STATUSES = [
    IN_QUEUE = :in_queue,
    IN_PROGRESS = :in_progress,
    FINISHED = :finished,
    FAILED = :failed,
  ]

  has_many :pages, dependent: :destroy
  belongs_to :bot

  enum status: STATUSES.each_with_object({}) { |k, o| o[k] = k.to_s }

  def still_running?
    in_queue? | in_progress?
  end

  def generate_csv
    CSV.generate do |csv|
      csv << bot.inspects.map(&:name)
      pages.each do |page|
        csv << page.data.values
      end
    end
  end
end
