class Admin::UsersController < Admin::BaseController
  before_action :_set_user, except: %i[index search new create]

  def index
    @datatable = UsersDatatable.new view_context
  end

  def search
    render json: UsersDatatable.new(view_context)
  end

  def show; end

  def new
    # we create on sign up form
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    # we create on sign up form
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @user, _user_params, admin_user_path(@user)
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: helpers.t_notice('successfully_deleted', User)
  end

  def _set_user
    @user = User.find params[:id]
  end

  def _user_params
    params.require(:user).permit(
      *User::FIELDS
    )
  end
end
