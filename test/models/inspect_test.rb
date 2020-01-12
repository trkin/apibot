require 'test_helper'

class InspectTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture inspects
  end
end
