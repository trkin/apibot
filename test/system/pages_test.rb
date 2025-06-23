require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  setup do
    sign_in fixture_user
  end

  test 'index and search' do
    visit run_path(fixture_page.run)
    assert_selector 'td', text: fixture_page.id.to_s
    fill_in 'Search', with: fixture_page.id
    assert_selector 'td', text: fixture_page.id.to_s
    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: fixture_page.id.to_s
  end

  test 'destroying a Page' do
    visit page_url(fixture_page)
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Page successfully deleted'
  end
end
