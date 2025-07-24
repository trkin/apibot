class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError


  # To stop a job you can use ApplicationJob.cancelled?(@run.job_id)
  def self.cancelled?(jid)
    return false unless jid.present?
    return false if Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }.zero?
    true
  end

  def self.cancel!(jid)
    raise ArgumentError, 'jid is blank' if jid.blank?
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
