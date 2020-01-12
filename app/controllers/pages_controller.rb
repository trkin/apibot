class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[
    notify_javascript_error
  ]

  def home
    @sign_up_company_form = SignUpCompanyForm.new
  end

  def sign_in_development
    return unless Rails.env.development? || Rails.application.credentials.is_staging || current_user&.superadmin?

    user = User.find params[:id]
    sign_in :user, user, byepass: true
    redirect_to params[:redirect_to] || root_path
  end

  def contact
    @contact = Contact.new(
      email: current_user&.email
    )
  end

  def submit_contact
    @contact = Contact.new(
      email: current_user&.email || params[:contact][:email],
      text: params[:contact][:text],
      g_recaptcha_response: params['g-recaptcha-response'],
      current_user: current_user,
      remote_ip: request.remote_ip,
    )
    if @contact.save
      redirect_to contact_path, notice: t('contact_thanks')
    else
      flash.now[:alert] = @contact.errors.full_messages.join(', ')
      render :contact
    end
  end

  def notify_javascript_error
    js_receivers = Rails.application.credentials.javascript_error_recipients
    if js_receivers.present?
      ExceptionNotifier.notify_exception(
        Exception.new(params[:errorMsg]),
        env: request.env,
        exception_recipients: js_receivers.to_s.split(','),
        data: {
          current_user: current_user,
          params: params
        }
      )
    end
    head :ok
  end
end
