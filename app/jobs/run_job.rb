# This is used only to invoke services so look there for details
class RunJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0
  def perform(run)
    result = PageService.new(run).perform
    run.pages.each do |page|
      result = InspectService.new(page).perform
      run.failed! unless result.success?
    end
    # UploadRunResult.new(run).perform
    result
  end
end
