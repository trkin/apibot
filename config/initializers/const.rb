class Const
  def self.common
    hash_or_error_if_key_does_not_exists(
      name: 'API BOT',
      # short_name is also use in config/sidekiq.yml and config/application.rb
      short_name: 'apibot',
      # default_url is required for links in email body or in links in controller
      # when url host is not available (for example rails console)
      default_url: {
        host: (Rails.env.production? ? 'apibot.herokuapp.com' : '127.0.0.1'),
        # by default system test is running on random port each time on host 127.0.0.1:44859
        # you can use fixed domain (myapp.localhost) and port (3333) in test/a/capybara.rb so you can use
        # port: (Rails.env.production? ? nil : Rails.env.development? ? Rack::Server.new.options[:Port] : 3333),
        port: (Rails.env.development? ? Rack::Server.new.options[:Port] : nil),
      },
    )
  end

  def self.examples
    hash_or_error_if_key_does_not_exists(
      number_of_books: 20,
      per_page: 9,
    )
  end

  def self.collapse_keys
    hash_or_error_if_key_does_not_exists(
      new_message: 'new_message',
    )
  end

  def self.hash_or_error_if_key_does_not_exists(hash)
    # https://stackoverflow.com/questions/30528699/why-isnt-an-exception-thrown-when-the-hash-value-doesnt-exist
    # raise if key does not exists hash[:non_exists] or hash.values_at[:non_exists]
    hash.default_proc = ->(_h, k) { raise KeyError, "#{k} not found!" }
    # raise when value not exists hash.key 'non_exists'
    def hash.key(value)
      k = super
      raise KeyError, "#{value} not found!" unless k

      k
    end
    hash
  end

  # https://stackoverflow.com/a/21249623/287166
  class ConstRailtie < Rails::Railtie
    link = Const.common[:default_url].symbolize_keys
    # for link urls in emails
    config.action_mailer.default_url_options = link
    # for link urls in rails console
    config.after_initialize do
      Rails.application.routes.default_url_options = link
    end
    # for asset-url or img_tag in emails
    config.action_mailer.asset_host = "http://#{link[:host]}:#{link[:port]}"
    config.active_job.queue_name_prefix = Const.common[:short_name]
  end
end
