require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @page = pages(:my_page)
    sign_in users(:user)
  end

  test 'should get index' do
    get run_path(@page.run)
    assert_response :success
    assert_select 'td', @page.id.to_s
  end

  test 'should search' do
    post search_run_pages_path(@page.run), params: { search: { value: @page.id } }
    assert_match @page.id.to_s, response_json[:data].join
    post search_run_pages_path(@page.run), params: { search: { value: 'blabla' } }
    refute_match @page.id.to_s, response_json[:data].join
  end

  test 'should show page' do
    get page_url(@page)
    assert_response :success
    assert_select 'dd', @page.id.to_s
  end

  test 'should destroy page' do
    assert_difference('Page.count', -1) do
      delete page_url(@page)
    end

    assert_redirected_to run_path(@page.run)
  end
end
