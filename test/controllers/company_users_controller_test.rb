require 'test_helper'

class CompanyUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @company_user = company_users(:my_company_user)
    sign_in users(:user)
  end

  test 'should get index' do
    get my_company_path
    assert_response :success
    assert_select 'td', @user.name
  end

  test 'should search' do
    post search_company_users_path, params: { search: { value: @user.name } }
    assert_match @user.name, response_json[:data].join
    post search_company_users_path, params: { search: { value: 'blabla' } }
    refute_match @user.name, response_json[:data].join
  end

  test 'should create user' do
    assert_difference('User.count') do
      post company_users_path, params: { company_user: { user_attributes: { name: @user.name, email: 'new@email', password: 'mypassword', password_confirmation: 'mypassword' }, position: CompanyUser.positions.first } }
    end

    assert_js_redirected_to my_company_path
  end

  test 'should update company_user' do
    patch company_user_url(@company_user), params: { company_user: { position: @company_user.position } }
    assert_js_redirected_to my_company_path
  end

  test 'should destroy company_user' do
    assert_difference('User.count', -1) do
      assert_difference('CompanyUser.count', -1) do
        delete company_user_url(@company_user)
      end
    end

    assert_redirected_to my_company_path
  end
end
