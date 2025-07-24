require 'test_helper'

class InspectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in fixture_user
  end

  test 'should get index' do
    get bot_path(fixture_inspect.bot)
    assert_response :success
    assert_select 'td', fixture_inspect.name
  end

  test 'should create inspect' do
    assert_difference('Inspect.count') do
      post bot_inspects_path(fixture_inspect.bot), params: { inspect: { name: "New Name", target: fixture_inspect.target } }
    end

    assert_js_redirected_to bot_path(Inspect.last.bot)
  end

  test 'should show inspect' do
    get inspect_url(fixture_inspect)
    assert_response :success
    assert_select 'dd', fixture_inspect.name
  end

  test 'should update inspect' do
    patch inspect_url(fixture_inspect), params: { inspect: { bot_id: fixture_inspect.bot_id, name: fixture_inspect.name, target: fixture_inspect.target } }
    assert_js_redirected_to bot_path(fixture_inspect.bot)
  end

  test 'should destroy inspect' do
    assert_difference('Inspect.count', -1) do
      delete inspect_url(fixture_inspect)
    end

    assert_redirected_to bot_path(fixture_inspect.bot)
  end
end
