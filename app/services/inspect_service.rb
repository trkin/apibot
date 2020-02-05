class InspectService
  def initialize(page)
    @page = page
    @doc = Nokogiri::HTML(@page.content)
  end

  def perform
    result = {}
    message = ''
    @page.run.bot.inspects.each do |inspect|
      # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri%2FXML%2FSearchable:css
      element = @doc.css(inspect.target)
      next if element.nil?
      if inspect.regexp.present?
        result[inspect.name] = element.text.scan(Regexp.new inspect.regexp).join
      else
        result[inspect.name] = element.text
      end
    end
    result[:external_page_url] = @page.url if @page.run.bot.config[:external_page_url]
    result[:internal_page_url] = Rails.application.routes.url_helpers.page_url(@page) if @page.run.bot.config[:internal_show_page_url]
    @page.data = result
    @page.error_log = nil
    @page.save!
    Result.new 'OK', message
  rescue StandardError => e
    @page.error_log = e.message
    @page.save!
    Error.new e.message
  end
end
