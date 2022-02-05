require 'test_helper'

class BotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bot = bots(:my_bot)
    sign_in users(:user)
  end

  test 'should get index' do
    get bots_path
    assert_response :success
    assert_select 'td', @bot.name
  end

  test 'should search' do
    post search_bots_path, params: { search: { value: @bot.name } }
    assert_match @bot.name, response_json[:data].join
    post search_bots_path, params: { search: { value: 'blabla' } }
    refute_match @bot.name, response_json[:data].join
  end

  test 'should create bot' do
    stub_bot_start_url
    assert_difference('Bot.count') do
      post bots_path, params: { bot: { name: 'my bot', engine: @bot.engine, start_url: @bot.start_url } }
    end

    assert_js_redirected_to bot_path(Bot.last)
    get bot_path(Bot.last)
    assert_select '[data-test=bot-name]', 'my bot'
  end

  test 'should show bot' do
    get bot_url(@bot)
    assert_response :success
    assert_select 'dd', @bot.name
  end

  test 'should update bot' do
    stub_bot_start_url
    patch bot_url(@bot), params: { bot: { company_id: @bot.company_id, name: @bot.name, start_url: @bot.start_url } }
    assert_js_redirected_to bot_path(@bot)
  end

  test 'should destroy bot' do
    assert_difference('Bot.count', -1) do
      delete bot_url(@bot)
    end

    assert_redirected_to bots_path
  end
end
