require 'test_helper'

class CompanyUserTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture company_users
  end
end
