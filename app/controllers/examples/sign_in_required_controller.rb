class Examples::SignInRequiredController < Examples::ApplicationController
  def index
    return if session[:username].present?
    redirect_to sign_in_required_login_path
  end

  def login
  end

  def submit_login
    session[:username] = params[:username]
    redirect_to sign_in_required_path
  end
end
