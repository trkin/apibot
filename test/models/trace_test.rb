require 'test_helper'

class TraceTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture traces
  end
end
