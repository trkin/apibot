# error [:browser_options] :options as a parameter for driver initialization is deprecated. Use :capabilities with an Array of value capabilities/options if necessary instead.
# https://github.com/teamcapybara/capybara/issues/2511#issuecomment-1010070206
Selenium::WebDriver.logger.ignore(:browser_options)
# Capybara initialization is in config/initializers/capybara.rb and for test env
# in test/a/capybara.rb
Capybara.configure do |config|
  # https://www.rubydoc.info/gems/capybara/Capybara#configure-class_method
  # we do not need to hardcode port because we do not use fixtures (which is
  # loaded before first capybara visit call) but we set start_url in test so we
  # can set port based on current_session server.port
  # config.server_port = 3333
end
