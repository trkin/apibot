require 'application_system_test_case'

class DeviseUserRegistrationAndLoginTest < ApplicationSystemTestCase
  def manual_register(email, password = 'password')
    visit new_user_registration_path
    fill_in User.human_attribute_name(:email), with: email
    fill_in User.human_attribute_name(:password), with: password
    fill_in User.human_attribute_name(:password_confirmation), with: password

    click_on t('my_devise.register')
  end

  def manual_login(email, password = 'password')
    visit new_user_session_path
    fill_in User.human_attribute_name(:email), with: email
    fill_in User.human_attribute_name(:password), with: password

    click_on t('my_devise.sign_in')
  end

  def assert_user_logged_in_with_email(email)
    assert_selector 'button', text: email
  end

  test 'register new user' do
    manual_register 'new@email.com', 'some_password'

    assert_text t('devise.registrations.signed_up_but_unconfirmed')
    user = User.find_by email: 'new@email.com'
    assert_equal I18n.default_locale.to_s, user.locale
  end

  test 'register user already exists' do
    email = users(:kayak_club_admin).email
    manual_register email
    assert_field_error t('errors.messages.taken')
  end

  test 'register already exists, email upercased' do
    email = users(:kayak_club_admin).email
    manual_register email.upcase
    assert_field_error t('errors.messages.taken')
  end

  test 'register already exists, email not striped' do
    email = users(:kayak_club_admin).email
    manual_register " #{email} "
    assert_field_error t('errors.messages.taken')
  end

  test 'login' do
    email = users(:kayak_club_admin).email
    manual_login email
    assert_user_logged_in_with_email email
  end

  test 'login, email upercased' do
    email = users(:kayak_club_admin).email
    manual_login email.upcase
    assert_user_logged_in_with_email email
  end

  test 'login, email not striped' do
    email = users(:kayak_club_admin).email
    manual_login " #{email} "
    assert_user_logged_in_with_email email
  end

  test 'forgot password' do
    user = users(:kayak_club_admin)
    visit new_user_password_path
    fill_in User.human_attribute_name(:email), with: user.email
    perform_enqueued_jobs only: ActionMailer::DeliveryJob do
      click_on t('my_devise.send_me_reset_password_instructions')
      assert_notice t('devise.passwords.send_instructions')
    end
    mail = give_me_last_mail_and_clear_mails
    link = mail.body.match("(http://.*)\">#{t('my_devise_mailer.change_password')}")[1]
    visit link
    fill_in t('my_devise.new_password'), with: 'new_password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'new_password'
    click_on t('update')

    user.reload
    assert user.valid_password? 'new_password'
  end

  test 'resend confirmation instructions' do
    user = users(:kayak_club_admin)
    user.confirmed_at = nil
    user.save!
    visit new_user_confirmation_path
    fill_in User.human_attribute_name(:email), with: user.email
    click_on t('send')

    assert_text t('devise.confirmations.send_instructions')
  end

  test 'resend unlock instructions' do
    return unless User.devise_modules.include?(:lockable) && User.unlock_strategy_enabled?(:email)

    user = users(:kayak_club_admin)
    user.locked_at = Time.zone.now
    user.save!
    visit new_user_unlock_path
    fill_in User.human_attribute_name(:email), with: user.email
    click_on t('my_devise.resend_unlock_instructions')

    assert_text t('devise.unlocks.send_instructions')
  end

#   test 'signup with facebook which does not have email should allow instant login' do
#     OmniAuth.config.test_mode = true
#     email = 'my@email.com'
#     password = 'password'
#     facebook_uid = SecureRandom.hex
#     OmniAuth.config.add_mock :facebook, uid: facebook_uid
#     visit '/'
#     find("a[title='#{t('my_devise.sign_in_with', provider: t('provider.facebook'))}']").click
#     # we could directly visit user_facebook_omniauth_authorize_path
#     fill_in User.human_attribute_name(:email), with: email
#     fill_in User.human_attribute_name(:password), with: password
#     fill_in User.human_attribute_name(:password_confirmation), with: password
#     click_on t('register')

#     assert_user_logged_in_with_email email

#     click_on email
#     click_on t('sign_out')
#     find("a[title='#{t('my_devise.sign_in_with', provider: t('provider.facebook'))}']").click
#     assert_user_logged_in_with_email email
#     user = User.last
#     assert_equal facebook_uid, user.facebook_uid

#     OmniAuth.config.test_mode = false
#   end
end
