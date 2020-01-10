require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture companies
  end
end
