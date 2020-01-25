if Rails.env.test?
  require 'webmock'
  # https://github.com/titusfortner/webdrivers/issues/109
  driver_urls = Webdrivers::Common.subclasses.map do |driver|
    Addressable::URI.parse(driver.base_url).host
  end
  WebMock.disable_net_connect!(allow_localhost: true, allow: driver_urls)
end
