require 'test_helper'

class BotTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture bots
  end
end
