class UsersDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'users.email': {},
      'users.name': {},
      'users.sign_in_count': {},
      'users.last_sign_in_at': {},
      'companies.name': {},
      'users.created_at': {}
    }
  end

  def all_items
    # you can use @view.params
    User.all.left_joins(:company)
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |user|
      link_to_login = @view.link_to("Log in as #{user.name}", @view.sign_in_development_path(user), class: 'btn btn-primary btn-sm')
      [
        @view.link_to(user.email, @view.admin_user_path(user)),
        link_to_login,
        user.sign_in_count,
        user.last_sign_in_at.to_s,
        user.company&.name,
        user.created_at.to_s(:short),
      ]
    end
  end
end
