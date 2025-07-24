require 'test_helper'

class BotTest < ActiveSupport::TestCase
  fixtures :all

  test 'valid fixture' do
    assert_valid_fixture bots
  end

  test "#duplicate" do
    duplicated_bot = fixture_bot.duplicate!
    assert_equal 1, duplicated_bot.inspects.count
    assert_equal 1, duplicated_bot.steps.count
    assert_equal 1, duplicated_bot.runs.count
  end
end
