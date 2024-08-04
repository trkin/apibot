class InspectService
  def initialize(page, inspect: nil, disable_save: false)
    @page = page
    @inspect = inspect
    @doc = Nokogiri::HTML(@page.content)
    @disable_save = disable_save
  end

  def perform
    result = {}
    inspects = if @inspect.present?
                 [@inspect]
               else
                 @page.run.bot.inspects
               end
    inspects.each do |inspect|
      # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri%2FXML%2FSearchable:css
      elements = @doc.css(inspect.target)
      next if elements.nil?
      element_value = if inspect.value_target == 'text'
                       elements.text
                     else
                       elements.map {|element| element[inspect.value_target] }.join(' ')
                     end
      if inspect.regexp.present?
        result[inspect.name] = element_value.scan(Regexp.new inspect.regexp).join
      else
        result[inspect.name] = element_value
      end
      inspect.transformations.each do |transformation|
        next if transformation.blank?
        case transformation
        when "titleize"
          result[inspect.name] = result[inspect.name].titleize
        when "upcase"
          result[inspect.name] = result[inspect.name].upcase
        when "downcase"
          result[inspect.name] = result[inspect.name].downcase
        else
          raise "unknown_transformation #{transformation}"
        end
      end
    end
    result[:include_page_url_in_data] = @page.url if @page.run.bot.config[:include_page_url_in_data] == '1'
    result[:include_apibot_url_in_data] = Rails.application.routes.url_helpers.page_url(@page) if @page.run.bot.config[:internal_show_page_url]
    @page.data = result
    @page.error_log = nil
    @page.save! unless @disable_save
    Result.new 'OK', result
  rescue StandardError => e
    # TODO: rescue only inspect errors, not all StandardError like ruby nil
    # or at least show the line number or what is causing the error
    message_and_backtrace = "#{e.message} #{e.backtrace.first}"
    @page.error_log = message_and_backtrace
    @page.save! unless @disable_save
    Error.new message_and_backtrace
  end
end
