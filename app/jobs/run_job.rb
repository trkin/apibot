# This is used only to invoke services so look there for details
class RunJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0
  def perform(run)
    result = PageService.new(run).perform
    return result unless result.success?

    run.pages.each do |page|
      result = InspectService.new(page).perform
      unless result.success?
        run.failed!
        return result
      end
    end
    # UploadRunResult.new(run).perform
    Result.new "Successfully run PageService and InspectService for #{run.pages.count} pages"
  end
end
