class TracesDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'traces.id': {},
      'traces.name': {},
    }
  end

  def all_items
    # you can use @view.params
    Trace.all
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |trace|
      [
        @view.link_to(trace.id, trace),
        trace.name,
      ]
    end
  end
end
