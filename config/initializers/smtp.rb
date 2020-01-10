Rails.application.config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  authentication: 'plain',
  enable_starttls_auto: true,
  user_name: Rails.application.credentials.smtp_username,
  password: Rails.application.credentials.smtp_password
}
