require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:my_step)
    sign_in users(:user)
  end

  test 'should get index' do
    get bot_path(@step.bot)
    assert_response :success
    assert_select 'td', @step.action
  end

  test 'should search' do
    post search_bot_steps_path(@step.bot), params: { search: { value: @step.action } }
    assert_match @step.action, response_json[:data].join
    post search_bot_steps_path, params: { search: { value: 'blabla' } }
    refute_match @step.action, response_json[:data].join
  end

  test 'should create step' do
    assert_difference('Step.count') do
      post bot_steps_path(@step.bot), params: { step: { action: @step.action, locator: @step.locator } }
    end

    assert_js_redirected_to bot_path(Step.last.bot)
  end

  test 'should update step' do
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
