class InspectService
  def initialize(page)
    @page = page
    @doc = Nokogiri::HTML(@page.content)
  end

  def perform
    result = {}
    message = ''
    @page.run.bot.inspects.each do |inspect|
      element = @doc.css(inspect.target)
      next if element.nil?
      if inspect.regexp.present?
        result[inspect.name] = element.text.scan(Regexp.new inspect.regexp).join
      else
        result[inspect.name] = element.text
      end
    end
    @page.data = result
    @page.save!
    Result.new 'OK', message
  end
end
