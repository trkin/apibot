class PagesDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'pages.id': { title: 'PageID' },
      'pages.url': { title: 'Page URL' },
      'pages.content': {},
      'pages.data': {},
    }
  end

  def all_items
    run = Run.joins(:bot).where(bots: { company: @view.current_user.company }).find(@view.params[:run_id] || @view.params[:id])
    run.pages
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |page|
      [
        @view.link_to(page.id, page),
        page.url,
        page.content.first(200),
        page.data.to_s,
      ]
    end
  end
end
