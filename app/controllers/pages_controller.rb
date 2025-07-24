class PagesController < ApplicationController
  before_action :_set_page, except: %i[index search new create]

  def index
    # index is on run show page
  end

  def search
    render json: PagesDatatable.new(view_context)
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data @page.run.generate_csv(selected_pages: Page.where(id: @page)), filename: "#{@page.run.bot.name}-#{@page.id}-#{Date.today}.csv" }
      format.json { render json: @run.generate_json(selected_pages: Page.where(id: @page)) }
    end
  end

  def content
    render html: @page.content.gsub(/display.none/, '').html_safe
  end

  def inspect
    result = InspectService.new(@page).perform
    if result.success?
      redirect_to page_path(@page), notice: 'Successfully inspected'
    else
      redirect_to page_path(@page), alert: result.message
    end
  end

  def new
    @page = Page.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @page = Page.new

    update_and_render_or_redirect_in_js @page, _page_params, ->(id) { page_path(id) }
  end

  def update
    update_and_render_or_redirect_in_js @page, _page_params, page_path(@page)
  end

  def destroy
    @page.destroy!
    redirect_to run_path(@page.run), notice: helpers.t_notice('successfully_deleted', Page)
  end

  def _set_page
    @page = Page.find(params[:id])
  end

  def _page_params
    params.require(:page).permit(
      *Page::FIELDS
    )
  end
end
