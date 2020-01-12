ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

Dir[Rails.root.join('test/a/**/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # t('successfully') instead I18n.t('successfully')
  include AbstractController::Translation
  # t_crud helper
  include TranslateHelper
  # devise method: sign_in user
  include Devise::Test::IntegrationHelpers

  def assert_valid_fixture(items)
    assert items.map(&:valid?).all?, (items.reject(&:valid?).map { |c| (c.respond_to?(:name) ? "#{c.name} " : '') + c.errors.full_messages.to_sentence })
  end

  def assert_js_redirected_to(path)
    assert_match /window.location.*#{path}/, response.body
  end

  def response_json
    HashWithIndifferentAccess.new JSON.parse response.body
  end
end
