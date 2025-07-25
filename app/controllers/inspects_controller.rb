class InspectsController < ApplicationUserController
  before_action :_set_inspect, except: %i[index new create calculate reorder update_position]
  before_action :_set_bot, only: %i[index new create calculate reorder update_position]

  def index
    # we index on bot show page
  end

  def show; end

  def new
    @inspect = @bot.inspects.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def duplicate
    @inspect = @inspect.bot.inspects.new @inspect.attributes
    render partial: 'form', layout: false
  end

  def create
    @inspect = @bot.inspects.new

    update_and_render_or_redirect_in_js @inspect, _inspect_params, ->(inspect) {
      InspectService.new(inspect.bot.last_page).perform if inspect.bot.last_page.present?
      bot_path(inspect.bot)
    }
  end

  def update
    update_and_render_or_redirect_in_js @inspect, _inspect_params, ->(inspect) {
      InspectService.new(inspect.bot.last_page).perform if inspect.bot.last_page.present?
      bot_path(inspect.bot)
    }
  end

  def destroy
    @inspect.destroy!
    redirect_to bot_path(@inspect.bot), notice: helpers.t_notice('successfully_deleted', Inspect)
  end

  def calculate
    return unless @bot.last_page.present?
    strip_params

    inspect = Inspect.new _inspect_params
    inspect.name = 'result' if inspect.name.blank?
    result = InspectService.new(@bot.last_page, inspect: inspect, disable_save: true).perform
    preview = if result.success?
                "\"#{result.data[inspect.name]}\""
              else
                "*** #{result.message} ***"
              end

    render json: {
      preview: preview
    }
  end

  def reorder
    @inspects = @bot.inspects.order(:position)
    render layout: false
  end

  def update_position
    @bot.inspects.each do |inspect|
      inspect.update! position: params[:bot][:inspect_ids].index(inspect.id.to_s) + 1
    end
    redirect_to bot_path(@bot), notice: helpers.t_notice('successfully_updated', Bot)
  end


  def _set_inspect
    @inspect = Inspect.joins(bot: :company).where(bots: { company: current_user.company }).find(params[:id])
  end

  def _set_bot
    @bot = current_user.company.bots.find params[:bot_id]
  end

  def _inspect_params
    params.require(:inspect).permit(
      *Inspect::FIELDS,
      transformations: [],
    )
  end
end
