class TaskWithErrorJob < ApplicationJob
  def perform
    raise 'This is sample_error_in_sidekiq'
  end
end
