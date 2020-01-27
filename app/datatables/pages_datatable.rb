class PagesDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'pages.id': { title: 'PageID' },
      'pages.url': { title: 'Page URL' },
      'pages.data': {},
      '': {},
    }
  end

  def global_search_columns
    # in addition to columns those fields will be used to match global search
    %w[pages.content]
  end

  def all_items
    run = Run.joins(:bot).where(bots: { company: @view.current_user.company }).find(@view.params[:run_id] || @view.params[:id])
    run.pages
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |page|
      actions = @view.link_to('Content <i class="demo-icon icon-link-ext"></i>'.html_safe, @view.content_page_path(page), target: :_blank)
      [
        @view.link_to(page.id, page),
        page.url,
        page.data.to_s,
        actions,
      ]
    end
  end
end
