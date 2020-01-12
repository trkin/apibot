require 'test_helper'

class AdminUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:superadmin)
    sign_in users(:superadmin)
  end

  test 'should get index' do
    get admin_users_path
    assert_response :success
    assert_select 'td', @user.email
  end

  test 'should search' do
    post search_admin_users_path, params: { search: { value: @user.name } }
    assert_match @user.name, response_json[:data].join
    post search_admin_users_path, params: { search: { value: 'blabla' } }
    refute_match @user.name, response_json[:data].join
  end

  test 'should show user' do
    get admin_user_url(@user)
    assert_response :success
    assert_select 'dd', @user.name
  end

  test 'should update user' do
    patch admin_user_url(@user), params: { user: { name: @user.name } }
    assert_js_redirected_to admin_user_path(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete admin_user_url(@user)
    end

    assert_redirected_to admin_users_path
  end
end
