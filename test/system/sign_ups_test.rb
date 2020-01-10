require 'application_system_test_case'

class SignUpsTest < ApplicationSystemTestCase
  test 'sign up' do
    visit new_user_registration_path
    fill_in User.human_attribute_name(:email), with: 'new@email.com'
    fill_in User.human_attribute_name(:password), with: 'asdfasdf'
    fill_in User.human_attribute_name(:password_confirmation), with: 'asdfasdf'
    assert_difference 'User.count', 1 do
      click_on t('my_devise.register')
      assert_notice t('devise.registrations.signed_up_but_unconfirmed')
    end
    user = User.find_by email: 'new@email.com'
    assert_equal I18n.default_locale, user.locale.to_sym
  end
end
