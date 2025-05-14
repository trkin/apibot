class TracesController < ApplicationController
  before_action :_set_trace, except: %i[index search new create]
  before_action :_set_bot, only: %i[index search new create]

  def index
    @datatable = TracesDatatable.new view_context
  end

  def search
    render json: TracesDatatable.new(view_context)
  end

  def show
  end

  def new
    @trace = @bot.traces.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @trace = @bot.traces.new

    update_and_render_or_redirect_in_js @trace, _trace_params, ->(trace) { trace_path(trace) }
  end

  def update
    update_and_render_or_redirect_in_js @trace, _trace_params, ->(trace) { trace_path(trace) }
  end

  def destroy
    @trace.destroy!
    redirect_to bot_path(@trace.bot), notice: helpers.t_notice('successfully_deleted', Trace)
  end

  def _set_trace
    @trace = Trace.find(params[:id])
  end

  def _trace_params
    params.require(:trace).permit(
      *Trace::FIELDS,
      config: Trace::CONFIG_BOOLEAN_KEYS,
      inspect_traces_attributes: [:id, :inspect_id, :_destroy],
    )
  end

  def _set_trace
    @trace = Trace.find params[:id]
  end

  def _set_bot
    @bot = current_user.company.bots.find params[:bot_id]
  end
end
