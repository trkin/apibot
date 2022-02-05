class BotsController < ApplicationUserController
  before_action :_set_bot, except: %i[index search new create]

  def index
    @datatable = BotsDatatable.new view_context
  end

  def search
    render json: BotsDatatable.new(view_context)
  end

  def show
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

    respond_to do |format|
      format.html do
        @bot.update _bot_params
        if @bot.new_record?
          flash[:alert] = @bot.errors.full_messages.to_sentence
          redirect_to bots_path
        else
          result = @bot.create_and_perform_run
          flash[:notice] = result.message
          redirect_to bot_path(@bot)
        end
      end
      format.js do
        update_and_render_or_redirect_in_js @bot, _bot_params, ->(bot) {
          result = bot.create_and_perform_run
          flash[:notice] = result.message
          bot_path(bot)
        }
      end
    end
  end

  def update
    update_and_render_or_redirect_in_js @bot, _bot_params, ->(bot) {
      result = bot.create_and_perform_run
      flash[:notice] = result.message
      bot_path(bot)
    }
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
      *Bot::FIELDS,
      config: Bot::CONFIG_BOOLEAN_KEYS,
      steps_attributes: Step::FIELDS + [filters: {}],
      inspects_attributes: Inspect::FIELDS,
    ).merge(
      company: current_user.company,
    )
  end
end
