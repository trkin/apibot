class RunsDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'runs.id': {},
      'bot.name': {},
      'runs.status': {},
      'runs.log': {},
      'runs.finished_at': {},
    }
  end

  def all_items
    # you can use @view.params
    Run.joins(:bot).where(bots: { company: @view.current_user.company })
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |run|
      log = "<details><summary>#{run.log.first(run.log.index('<br>') || 100)}</summary>#{run.log}</details>".html_safe if run.log.present?
      [
        @view.link_to(run.id, run),
        @view.link_to(run.bot.name_or_start_url, @view.bot_path(run.bot)),
        run.status,
        log,
        run.finished_at,
      ]
    end
  end
end
