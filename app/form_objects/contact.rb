class Contact
  include ActiveModel::Model
  include Recaptcha::Adapters::ControllerMethods

  attr_accessor :email, :text, :g_recaptcha_response, :current_user, :remote_ip
  validates_format_of :email, with: Devise.email_regexp
  validates :text, :email, presence: true

  def save
    unless current_user&.confirmed?
      verify_recaptcha model: self, response: g_recaptcha_response
      return false if errors.present?
    end
    return false unless valid?

    _send_notification
    true
  end

  def request
    OpenStruct.new remote_ip: remote_ip
  end

  def _send_notification
    Notify.message("contact_form #{email} @ #{Time.zone.now}", email, text, remote_ip, current_user)
  end
end
