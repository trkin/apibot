Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.google_recaptcha_site_key
  config.secret_key = Rails.application.credentials.google_recaptcha_secret_key
end
