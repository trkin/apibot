require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  setup do
    @page = pages(:my_page)
    sign_in users(:user)
  end

  test 'index and search' do
    visit run_path(@page.run)
    assert_selector 'td', text: @page.id.to_s
    fill_in 'Search', with: @page.id
    assert_selector 'td', text: @page.id.to_s
    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: @page.id.to_s
  end

  test 'destroying a Page' do
    visit page_url(@page)
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Page successfully deleted'
  end
end
