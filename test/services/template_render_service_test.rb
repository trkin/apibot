require "test_helper"

class TemplateRenderServiceTest < ActiveSupport::TestCase

  test "#render with non asci" do
    service = TemplateRenderService.new ">", {}
    result = service.render
    assert_equal ">", result.message
  end
end
