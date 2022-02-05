class BotsDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'bots.id': {},
      'bots.start_url': {},
      'bots.name': {},
    }
  end

  def all_items
    # you can use @view.params
    @view.current_user.company.bots
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |bot|
      [
        @view.link_to(bot.id, bot),
        bot.start_url,
        bot.name,
      ]
    end
  end
end
