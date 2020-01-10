class MyCompaniesController < ApplicationUserController
  def show
    @datatable = CompanyUsersDatatable.new view_context
  end

  def edit
    @company = current_user.company
    render partial: 'form', layout: false
  end

  def update
    @company = current_user.company
    update_and_render_or_redirect_in_js @company, _company_params, my_company_path
  end

  def _company_params
    params.require(:company).permit(
      *Company::FIELDS
    )
  end
end
