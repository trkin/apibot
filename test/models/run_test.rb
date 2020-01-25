require 'test_helper'

class RunTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture runs
  end
end
