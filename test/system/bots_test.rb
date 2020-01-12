require 'application_system_test_case'

class BotsTest < ApplicationSystemTestCase
  setup do
    @bot = bots(:my_bot)
    sign_in users(:user)
  end

  test 'index and search' do
    visit bots_url
    assert_selector 'td', text: @bot.name
    fill_in 'Search', with: @bot.name
    assert_selector 'td', text: @bot.name
    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: @bot.name
  end

  test 'creating a Bot' do
    visit bots_url
    click_on 'Add new bot'

    fill_in 'Name', with: @bot.name
    fill_in 'Start url', with: @bot.start_url
    click_on 'Create Bot'

    assert_notice 'Bot successfully created'
  end

  test 'updating a Bot' do
    visit bots_url
    click_on @bot.id.to_s
    click_on 'Edit', match: :first

    fill_in 'Name', with: 'blabla'
    click_on 'Update Bot'

    assert_notice 'Bot successfully updated'
    assert_selector 'dd', text: 'blabla'
  end

  test 'destroying a Bot' do
    visit bots_url
    click_on @bot.id.to_s
    click_on 'Edit', match: :first
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Bot successfully deleted'
  end
end
