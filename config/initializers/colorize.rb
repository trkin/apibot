class String
  COLOR = 31 # red

  def red
    "\e[#{COLOR}m#{self}\e[0m"
  end

  def colorize(string, return_nil: true, only_matched_lines: false)
    last_index = 0
    res = ''
    while (new_index = self[last_index..-1].index(string))
      if last_index + new_index - 1 > -1
        res += self[last_index..last_index + new_index - 1]
      end
      res += string.red
      last_index = last_index + new_index + string.length
    end
    res += self[last_index..-1]
    if only_matched_lines
      res = res.split("\n").select { |l| l.index string }.join("\n")
    end
    # rubocop:disable Rails/Output
    puts res
    # rubocop:enable Rails/Output
    return_nil ? nil : res
  end
end

## run tests with a command
## rails test config/initializers/colorize.rb
# require 'minitest/autorun'
# class Test < Minitest::Test
#   def test_one_substring
#     s = 'My name is John.'
#     assert_equal "My name is \e[31mJohn\e[0m.", s.colorize('John', return_nil: false)
#   end
#
#   def test_two_substrings
#     s = 'John is my name, John.'
#     r = "\e[31mJohn\e[0m is my name, \e[31mJohn\e[0m."
#     assert_equal r, s.colorize('John', return_nil: false)
#   end
#
#   def test_no_found
#     s = 'My name is John.'
#     assert_equal "My name is John.", s.colorize('Mike', return_nil: false)
#   end
#
#   def test_whole
#     s = 'My name is John.'
#     assert_equal "\e[31mMy name is John.\e[0m", s.colorize(s, return_nil: false)
#   end
#
#   def test_return
#     s = 'My name is John.'
#     assert_nil s.colorize('John')
#   end
#
#   def test_only_matched_lines
#     s = "first_line\nsecond_line John\nthird_line\nJohn fourth_line"
#     assert_equal "second_line #{'John'.red}\n#{'John'.red} fourth_line", s.colorize('John', only_matched_lines: true, return_nil: false)
#   end
# end
