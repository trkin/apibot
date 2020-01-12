class DashboardsController < ApplicationUserController
  def show; end

  def resend_confirmation_instructions
    current_user.send_confirmation_instructions
    redirect_to dashboard_path, notice: t('devise.registrations.signed_up_but_unconfirmed')
  end
end
