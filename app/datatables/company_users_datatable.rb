class CompanyUsersDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'users.name': {},
      'users.email': {},
      'company_users.position': {},
      '': {}
    }
  end

  def all_items
    # you can use @view.params
    @view.current_user.company.company_users.joins(:user)
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |company_user|
      link = @view.button_tag_open_modal @view.edit_company_user_path(company_user)
      [
        company_user.user.name,
        company_user.user.email,
        company_user.position,
        link,
      ]
    end
  end
end
