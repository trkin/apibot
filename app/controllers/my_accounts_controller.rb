class MyAccountsController < ApplicationUserController
  def show; end

  def change_email
    render partial: 'change_email', layout: false
  end

  def change_password
    render partial: 'change_password', layout: false
  end

  def edit
    @user = current_user
    render partial: 'form', layout: false
  end

  def update
    @user = current_user
    partial = 'form'
    partial = params[:partial] if %w[change_email].include? params[:partial]
    update_and_render_or_redirect_in_js @user, _user_params, my_account_path, partial
  end

  def update_password
    @user = current_user
    unless current_user.valid_password? params[:user][:current_password]
      current_user.errors.add(:current_password, t('my_devise.current_password_is_not_correct'))
    end
    notice = t('data_item_name_successfully_updated', item_name: User.human_attribute_name(:password))
    update_and_render_or_redirect_in_js @user, _user_params, my_account_path, 'change_password', notice
    bypass_sign_in current_user if current_user.errors.blank?
  end

  def _user_params
    params.require(:user).permit(
      *User::FIELDS
    )
  end
end
