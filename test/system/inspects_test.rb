require 'application_system_test_case'

class InspectsTest < ApplicationSystemTestCase
  setup do
    sign_in fixture_user
  end

  test 'index and search' do
    visit bot_path(fixture_inspect.bot)
    assert_selector 'td', text: fixture_inspect.name
  end

  test 'creating a Inspect' do
    visit bot_path(fixture_inspect.bot)
    click_on 'Add new inspect'

    fill_in 'Name', with: fixture_inspect.name
    fill_in 'Target', with: fixture_inspect.target
    click_on 'Create Inspect'

    assert_notice 'Inspect successfully created'
  end

  test 'updating a Inspect' do
    visit bot_path(fixture_inspect.bot)
    within '[data-test=inspects]' do
      click_on 'Edit', match: :first
    end

    fill_in 'Name', with: 'blabla'
    click_on 'Update Inspect'

    assert_notice 'Inspect successfully updated'
    assert_selector 'td', text: 'blabla'
  end

  test 'destroying a Inspect' do
    visit bot_path(fixture_inspect.bot)
    within '[data-test=inspects]' do
      click_on 'Edit', match: :first
    end
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Inspect successfully deleted'
  end
end
