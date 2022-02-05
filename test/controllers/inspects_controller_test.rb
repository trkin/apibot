require 'test_helper'

class InspectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inspect = inspects(:my_inspect)
    sign_in users(:user)
  end

  test 'should get index' do
    get bot_path(@inspect.bot)
    assert_response :success
    assert_select 'td', @inspect.name
  end

  test 'should create inspect' do
    assert_difference('Inspect.count') do
      post bot_inspects_path(@inspect.bot), params: { inspect: { name: @inspect.name, target: @inspect.target } }
    end

    assert_js_redirected_to bot_path(Inspect.last.bot)
  end

  test 'should show inspect' do
    get inspect_url(@inspect)
    assert_response :success
    assert_select 'dd', @inspect.name
  end

  test 'should update inspect' do
    patch inspect_url(@inspect), params: { inspect: { bot_id: @inspect.bot_id, name: @inspect.name, target: @inspect.target } }
    assert_js_redirected_to bot_path(@inspect.bot)
  end

  test 'should destroy inspect' do
    assert_difference('Inspect.count', -1) do
      delete inspect_url(@inspect)
    end

    assert_redirected_to bot_path(@inspect.bot)
  end
end
