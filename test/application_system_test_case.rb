require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # On CI Github Actions we need to use headless_chrome
  # also Redis has to be installed
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def display_image
    system "gnome-open #{image_path} &"
    "Opening screenshot: gnome-open #{image_path}"
  end

  # you can use byebug, but it will stop rails so you can not navigate to other
  # pages or make another requests in chrome while testing
  def pause
    $stderr.write('Press CTRL+j or ENTER to continue') && $stdin.gets
  end
end
