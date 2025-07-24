require 'application_system_test_case'

class RunsTest < ApplicationSystemTestCase
  setup do
    @run = runs(:run)
    sign_in users(:user)
  end

  test 'index and search' do
    visit runs_url
    assert_selector 'td', text: @run.bot.name
    fill_in 'Search', with: @run.bot_id
    assert_selector 'td', text: @run.bot.name
    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: @run.bot.name
  end

  # test 'creating a Run' do
  #   visit runs_url
  #   find('label', text: 'Run').click
  #   click_button @run.bot.name_or_start_url

  #   assert_notice 'Run successfully created'
  # end

  test 'destroying a Run' do
    visit runs_url
    click_on @run.id.to_s
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Run successfully deleted'
  end
end
