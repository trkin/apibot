require 'application_system_test_case'

class StepsTest < ApplicationSystemTestCase
  setup do
    @step = steps(:my_step)
    sign_in users(:user)
  end

  test 'index and search' do
    visit bot_path(@step.bot)
    assert_selector 'td', text: @step.what
    within '[data-test=steps]' do
      fill_in 'Search', with: @step.what
    end
    assert_selector 'td', text: @step.what
    within '[data-test=steps]' do
      fill_in 'Search', with: 'blabla'
    end
    refute_selector 'td', text: @step.what
  end

  test 'creating a Step' do
    visit bot_path(@step.bot)
    click_on 'Add new step'

    select @step.action, from: 'Action'
    fill_in 'What', with: @step.what
    fill_in 'With', with: @step.with
    click_on 'Create Step'

    assert_notice 'Step successfully created'
  end

  test 'updating a Step' do
    visit bot_path(@step.bot)
    within '[data-test=steps]' do
      click_on 'Edit', match: :first
    end

    fill_in 'What', with: 'blabla'
    click_on 'Update Step'

    assert_notice 'Step successfully updated'
    assert_selector 'td', text: 'blabla'
  end

  test 'destroying a Step' do
    visit bot_path(@step.bot)
    within '[data-test=steps]' do
      click_on 'Edit', match: :first
    end
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Step successfully deleted'
  end
end
