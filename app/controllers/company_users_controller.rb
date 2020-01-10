class CompanyUsersController < ApplicationUserController
  before_action :_set_company_user, only: %i[edit update destroy]

  def new
    @company_user = CompanyUser.new company: current_user.company, user: User.new
    render partial: 'create_form', layout: false
  end

  def create
    @company_user = CompanyUser.new company: current_user.company, user: User.new(company: current_user.company)
    update_and_render_or_redirect_in_js @company_user, _company_user_params, my_company_path, 'create_form'
  end

  def search
    render json: CompanyUsersDatatable.new(view_context)
  end

  def edit
    render partial: 'form', layout: false
  end

  def update
    update_and_render_or_redirect_in_js @company_user, _company_user_params, my_company_path
  end

  def destroy
    @company_user.user.remove_me_from_company! current_user.company
    @company_user.destroy!
    redirect_to my_company_path
  end

  def _company_user_params
    params.require(:company_user).permit(
      *CompanyUser::FIELDS,
      user_attributes: User::FIELDS,
    )
  end

  def _set_company_user
    @company_user = current_user.company.company_users.find params[:id]
  end
end
