class RunsDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'runs.id': {},
      'bot.id': { hide: true },
      'bot.name': {},
      'runs.status': {},
      'runs.log': {},
      'integer_calculated_in_db.pages_count': {},
      'runs.finished_at': {},
    }
  end

  def all_items
    # you can use @view.params
    Run
      .joins(:bot)
      .where(bots: { company: @view.current_user.company })
      .select(
      %(
        runs.*,
        #{pages_count} AS pages_count
      ))
  end

  def all_items_count
    all_items.returns_count_sum.count
  end

  def filtered_items_count
    filtered_items.returns_count_sum.count
  end

  def pages_count
    <<~SQL
     (
      SELECT COUNT(*) FROM pages
      WHERE pages.run_id = runs.id
     )
    SQL
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |run|
      log = "<details><summary>#{run.log.first(run.log.index('<br>') || 100)}</summary>#{run.log}</details>".html_safe if run.log.present?
      [
        @view.link_to(run.id, run),
        run.bot_id,
        @view.link_to(run.bot.name_or_start_url, @view.bot_path(run.bot)),
        @view.badge_for_status(run.status),
        log,
        run.pages_count,
        run.finished_at,
      ]
    end
  end
end
