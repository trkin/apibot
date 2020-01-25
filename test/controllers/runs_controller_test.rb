require 'test_helper'

class RunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @run = runs(:my_run)
    sign_in users(:user)
  end

  test 'should get index' do
    get runs_path
    assert_response :success
    assert_select 'td', @run.id.to_s
  end

  test 'should search' do
    post search_runs_path, params: { search: { value: @run.id } }
    assert_match @run.id.to_s, response_json[:data].join
    post search_runs_path, params: { search: { value: 'blabla' } }
    refute_match @run.id.to_s, response_json[:data].join
  end

  # test 'should create run' do
  #   assert_difference('Run.count') do
  #     post runs_path, params: { bot_id: @run.bot_id }
  #   end

  #   assert_redirected_to run_path(Run.order(created_at: :asc).last)
  # end

  test 'should show run' do
    get run_url(@run)
    assert_response :success
    assert_select 'dd', @run.id.to_s
  end

  test 'should destroy run' do
    assert_difference('Run.count', -1) do
      delete run_url(@run)
    end

    assert_redirected_to runs_path
  end
end
