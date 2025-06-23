require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in fixture_user
  end

  test 'should get index' do
    get run_path(fixture_page.run)
    assert_response :success
    assert_select 'td', fixture_page.id.to_s
  end

  test 'should search' do
    post search_run_pages_path(fixture_page.run), params: { search: { value: fixture_page.id } }
    assert_match fixture_page.id.to_s, response_json[:data].join
    post search_run_pages_path(fixture_page.run), params: { search: { value: 'blabla' } }
    refute_match fixture_page.id.to_s, response_json[:data].join
  end

  test 'should show page' do
    get page_url(fixture_page)
    assert_response :success
    assert_select 'dd', fixture_page.id.to_s
  end

  test 'should destroy page' do
    assert_difference('Page.count', -1) do
      delete page_url(fixture_page)
    end

    assert_redirected_to run_path(fixture_page.run)
  end
end
