require 'application_system_test_case'

class SignUpsTest < ApplicationSystemTestCase
  test 'sign up' do
    visit root_path
    fill_in SignUpCompanyForm.human_attribute_name(:company), with: 'My company'
    fill_in SignUpCompanyForm.human_attribute_name(:name), with: 'My name'
    fill_in SignUpCompanyForm.human_attribute_name(:email), with: 'new@email.com'
    fill_in SignUpCompanyForm.human_attribute_name(:password), with: 'my_password'
    assert_difference 'User.count', 1 do
      click_on 'SIGN UP'
      assert_notice t('devise.registrations.signed_up_but_unconfirmed')
      assert_selector 'a', text: 'Login'
    end
    user = User.find_by email: 'new@email.com'
    assert user
  end
end
