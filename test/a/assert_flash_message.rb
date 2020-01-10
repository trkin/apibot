class ActionDispatch::IntegrationTest
  # assert_flash_message with something like
  # assert_alert /You are already registered/
  def assert_alert(text)
    assert_select '[data-test=alert-holder]', text
  end

  def assert_notice(text)
    assert_select '[data-test=notice-holder]', text
  end

  def assert_field_error(text)
    assert_select 'div.invalid-feedback', text
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  def assert_alert(text)
    assert_selector '[data-test=alert-holder]', text: text, visible: false
  end

  def assert_notice(text)
    assert_selector '[data-test=notice-holder]', text: text, visible: false
  end

  def assert_field_error(text)
    assert_selector 'div.invalid-feedback', text: text
  end
end
