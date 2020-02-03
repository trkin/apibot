class RunsController < ApplicationUserController
  before_action :_set_run, except: %i[index search new create]

  def index
    @datatable = RunsDatatable.new view_context
  end

  def search
    render json: RunsDatatable.new(view_context)
  end

  def show
    respond_to do |format|
      format.html { @datatable = PagesDatatable.new view_context }
      format.csv { send_data @run.generate_csv, filename: "#{@run.bot.name}-#{Date.today}.csv" }
      format.json { render json: @run.generate_json }
    end
  end

  def inspect_all
    error_messages = []
    @run.pages.each do |page|
      result = InspectService.new(page).perform
      error_messages.append result.message unless result.success?
    end
    if error_messages.present?
      redirect_to run_path(@run), alert: error_messages.to_sentence
    else
      redirect_to run_path(@run), notice: 'Inspect all successully'
    end
  end

  def new
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    bot = current_user.company.bots.find(params[:bot_id])
    @run = bot.runs.create! status: Run::IN_QUEUE
    if params[:run_now]
      RunJob.perform_now @run
    else
      job = RunJob.perform_later @run
      @run.job_id = job.job_id
      @run.save!
    end

    redirect_to run_path(@run), notice: helpers.t_notice('successfully_created', Run)
  end

  def cancel
    ApplicationJob.cancel! @run.job_id
    redirect_to run_path(@run), notice: "Job #{@run.job_id} should stop soon"
  end

  def update
    update_and_render_or_redirect_in_js @run, _run_params, run_path(@run)
  end

  def destroy
    @run.destroy!
    redirect_to runs_path, notice: helpers.t_notice('successfully_deleted', Run)
  end

  def _set_run
    @run = Run.find(params[:id])
  end

  def _run_params
    params.require(:run).permit(
      *Run::FIELDS
    )
  end
end
