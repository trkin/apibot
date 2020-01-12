class StepsDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'steps.position': { order: false },
      'steps.action': { order: false },
      'steps.what': { order: false },
      'steps.with': { order: false },
      '': {},
    }
  end

  def default_order
    [[0, :asc]]
  end

  def all_items
    # you can use @view.params
    bot = @view.current_user.company.bots.find(@view.params[:bot_id] || @view.params[:id])
    bot.steps
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |step|
      links = @view.button_tag_open_modal @view.edit_step_path(step)
      [
        step.position,
        step.action,
        step.what,
        step.with,
        links,
      ]
    end
  end
end
