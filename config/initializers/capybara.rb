# Capybara initialization is in config/initializers/capybara.rb and for test env
# in test/a/capybara.rb
Capybara.register_driver :mechanize do |app|
  # https://github.com/jeroenvandijk/capybara-mechanize/issues/66
  # Capybara::Mechanize::Driver.new app   # not good
  Capybara::Mechanize::Driver.new(proc {})
end
