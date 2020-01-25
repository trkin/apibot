# This is used only to invoke services so look there for details
class RunJob < ApplicationJob
  queue_as :default
  def perform(run)
    result = StepService.new(run).perform
    run.pages.each do |page|
      result = InspectService.new(page).perform
      run.failed! unless result.success?
    end
    # UploadRunResult.new(run).perform
  end
end
