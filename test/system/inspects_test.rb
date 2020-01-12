require 'application_system_test_case'

class InspectsTest < ApplicationSystemTestCase
  setup do
    @inspect = inspects(:my_inspect)
    sign_in users(:user)
  end

  test 'index and search' do
    visit bot_path(@inspect.bot)
    assert_selector 'td', text: @inspect.name
    within '[data-test=inspects]' do
      fill_in 'Search', with: @inspect.name
    end
    assert_selector 'td', text: @inspect.name
    within '[data-test=inspects]' do
      fill_in 'Search', with: 'blabla'
    end
    refute_selector 'td', text: @inspect.name
  end

  test 'creating a Inspect' do
    visit bot_path(@inspect.bot)
    click_on 'Add new inspect'

    fill_in 'Name', with: @inspect.name
    fill_in 'Target', with: @inspect.target
    click_on 'Create Inspect'

    assert_notice 'Inspect successfully created'
  end

  test 'updating a Inspect' do
    visit bot_path(@inspect.bot)
    within '[data-test=inspects]' do
      click_on 'Edit', match: :first
    end

    fill_in 'Name', with: 'blabla'
    click_on 'Update Inspect'

    assert_notice 'Inspect successfully updated'
    assert_selector 'td', text: 'blabla'
  end

  test 'destroying a Inspect' do
    visit bot_path(@inspect.bot)
    within '[data-test=inspects]' do
      click_on 'Edit', match: :first
    end
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Inspect successfully deleted'
  end
end
