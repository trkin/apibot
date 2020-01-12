require 'application_system_test_case'

class MyAccountsTest < ApplicationSystemTestCase
  test 'change email' do
    sign_in users(:user)
    visit my_account_path
    click_on t('change_item_name', item_name: User.human_attribute_name(:email))
    within '#remote-form' do
      fill_in User.human_attribute_name(:email), with: 'new@email.com'
      click_on t('update')
    end
    assert_selector 'dd', text: t('my_devise.currently_waiting_confirmation_for', item: 'new@email.com')
  end

  test 'change password' do
    user = users(:user)
    sign_in user
    visit my_account_path
    click_on t('change_item_name', item_name: User.human_attribute_name(:password))
    fill_in User.human_attribute_name(:current_password), with: 'wrong'
    fill_in User.human_attribute_name(:password), with: 'newpass'
    fill_in User.human_attribute_name(:password_confirmation), with: 'newpass'
    click_on t('update')
    assert_alert t('my_devise.current_password_is_not_correct')
    fill_in User.human_attribute_name(:current_password), with: 'password'
    fill_in User.human_attribute_name(:password), with: 'newpass'
    fill_in User.human_attribute_name(:password_confirmation), with: 'newpass'
    click_on t('update')
    assert_notice t('data_item_name_successfully_updated', item_name: User.human_attribute_name(:password))
    user.reload
    user.valid_password? 'new_pass'
  end

  test 'cancel' do
    sign_in users(:user)
    visit my_account_path
    click_on t('my_devise.cancel_my_account')
    assert_difference 'User.count', -1 do
      page.driver.browser.switch_to.alert.accept
      assert_notice t('devise.registrations.destroyed')
    end
  end
end
