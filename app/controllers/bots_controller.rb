class BotsController < ApplicationUserController
  before_action :_set_bot, except: %i[index search new create]

  def index
    @datatable = BotsDatatable.new view_context
  end

  def search
    render json: BotsDatatable.new(view_context)
  end

  def show
    @steps_datatable = StepsDatatable.new view_context
    @inspects_datatable = InspectsDatatable.new view_context
  end

  def new
    @bot = Bot.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @bot = Bot.new

    update_and_render_or_redirect_in_js @bot, _bot_params, ->(id) { bot_path(id) }
  end

  def update
    update_and_render_or_redirect_in_js @bot, _bot_params, bot_path(@bot)
  end

  def destroy
    @bot.destroy!
    redirect_to bots_path, notice: helpers.t_notice('successfully_deleted', Bot)
  end

  def _set_bot
    @bot = Bot.find(params[:id])
  end

  def _bot_params
    params.require(:bot).permit(
      *Bot::FIELDS
    ).merge(
      company: current_user.company,
    )
  end
end
