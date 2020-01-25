class InspectsDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'inspects.name': {},
      'inspects.target': {},
      'inspects.regexp': {},
      '': {},
    }
  end

  def all_items
    # we are on bot show page but also on search
    bot = @view.current_user.company.bots.find(@view.params[:bot_id] || @view.params[:id])
    bot.inspects
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |inspect|
      links = @view.button_tag_open_modal @view.edit_inspect_path(inspect)
      [
        inspect.name,
        inspect.target,
        inspect.regexp,
        links
      ]
    end
  end
end
