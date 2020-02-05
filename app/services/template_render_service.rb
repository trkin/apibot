class TemplateRenderService
  attr_reader :template, :data

  def initialize(template, data)
    @template = template
    @data = data
  end

  def render
    m = Mustache.new
    m.raise_on_context_miss = true
    rendered = m.render(template, data)
    Result.new rendered
  rescue Mustache::ContextMiss, Mustache::Parser::SyntaxError => e
    Error.new e.message
  end
end
