class StepsController < ApplicationController
  before_action :_set_step, except: %i[index search new create]
  before_action :_set_bot, only: %i[index search new create]

  def index
    # we index on bot show page
  end

  def search
    render json: StepsDatatable.new(view_context)
  end

  def show; end

  def new
    @step = @bot.steps.new(
      action: StepService::ALL_ACTIONS.first,
      selector_type: :css,
    )
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @step = @bot.steps.new
    @step.filters = params[:step][:filter_keys].zip(params[:step][:filter_values]).to_h if params[:step][:filter_values].present?

    update_and_render_or_redirect_in_js @step, _step_params, bot_path(@bot)
  end

  def update
    @step.filters = params[:step][:filter_keys].zip(params[:step][:filter_values]).to_h if params[:step][:filter_values].present?
    update_and_render_or_redirect_in_js @step, _step_params, bot_path(@step.bot)
  end

  def destroy
    @step.destroy!
    redirect_to bot_path(@step.bot), notice: helpers.t_notice('successfully_deleted', Step)
  end

  def _set_step
    @step = Step.joins(bot: :company).where(bots: { company: current_user.company }).find(params[:id])
  end

  def _set_bot
    @bot = current_user.company.bots.find params[:bot_id]
  end

  def _step_params
    params.require(:step).permit(
      *Step::FIELDS
    )
  end
end
