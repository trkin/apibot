class InspectsController < ApplicationUserController
  before_action :_set_inspect, except: %i[index search new create]
  before_action :_set_bot, only: %i[index search new create]

  def index
    # we index on bot show page
  end

  def search
    render json: InspectsDatatable.new(view_context)
  end

  def show; end

  def new
    @inspect = @bot.inspects.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @inspect = @bot.inspects.new

    update_and_render_or_redirect_in_js @inspect, _inspect_params, bot_path(@bot)
  end

  def update
    update_and_render_or_redirect_in_js @inspect, _inspect_params, bot_path(@inspect.bot)
  end

  def destroy
    @inspect.destroy!
    redirect_to bot_path(@inspect.bot), notice: helpers.t_notice('successfully_deleted', Inspect)
  end

  def _set_inspect
    @inspect = Inspect.joins(bot: :company).where(bots: { company: current_user.company }).find(params[:id])
  end

  def _set_bot
    @bot = current_user.company.bots.find params[:bot_id]
  end

  def _inspect_params
    params.require(:inspect).permit(
      *Inspect::FIELDS
    )
  end
end
