require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:step)
    sign_in users(:user)
  end

  test 'should get index' do
    get bot_path(@step.bot)
    assert_response :success
    assert_select 'td', @step.action
  end

  test 'should create step' do
    stub_bot_start_url
    assert_difference('Step.count') do
      post bot_steps_path(@step.bot), params: { step: { action: @step.action, locator: @step.locator } }
    end

    assert_js_redirected_to bot_path(Step.last.bot)
  end

  test 'should update step' do
    stub_bot_start_url
    patch step_url(@step), params: { step: { action: @step.action, locator: @step.locator } }
    assert_js_redirected_to bot_path(@step.bot)
  end

  test 'should destroy step' do
    assert_difference('Step.count', -1) do
      delete step_url(@step)
    end

    assert_redirected_to bot_path(@step.bot)
  end
end
