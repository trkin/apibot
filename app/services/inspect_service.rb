class InspectService
  def initialize(page = nil, inspect: nil, disable_save: false)
    @page = page
    @inspect = inspect
    @disable_save = disable_save
    @page.error_log = nil
    @page.save! unless @disable_save
  end

  def perform
    result_hash = {}
    inspects = if @inspect.present?
                 [@inspect]
               else
                 @page.run.bot.inspects
               end
    inspects.each do |inspect|
      result = get_value @page.content, inspect.target, inspect.target_attribute, inspect.regexp, inspect.ignore_error_when_element_not_found
      return result unless result.success?

      value = result.data[:value]
      inspect.transformations.each do |transformation|
        next if transformation.blank?
        # TRANSFORMATIONS
        value = case transformation
        when "titleize"
          value.titleize
        when "upcase"
          value.upcase
        when "downcase"
          value.downcase
        when "to_lat"
          value.to_lat
        when "to_cyr"
          value.to_cyr
        when "slugify"
          Jekyll::Utils.slugify value
        when "uri_escape"
          URI::DEFAULT_PARSER.escape value
        else
          raise "unknown_transformation #{transformation}"
        end
      end
      result_hash[inspect.name] = value
    end
    inspects.each do |inspect|
      result_hash[inspect.name] = interpolate result_hash[inspect.name], inspect.interpolation, result_hash
    end
    result_hash[:include_page_url_in_data] = @page.url if @page.run.bot.config[:include_page_url_in_data] == '1'
    result_hash[:include_apibot_url_in_data] = Rails.application.routes.url_helpers.page_url(@page) if @page.run.bot.config[:internal_show_page_url]
    @page.data = result_hash
    @page.error_log = nil
    @page.save! unless @disable_save
    Result.new 'OK', result_hash
  end

  def get_value(content, target, target_attribute, regexp = "", ignore_error_when_element_not_found = false)
    # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri%2FXML%2FSearchable:css
    doc = Nokogiri::HTML(content)
    begin
    element = doc.at target
    rescue Nokogiri::XML::XPath::SyntaxError => e
      return @page.log_error Error.new "APIBOT_NOKOGIRI: #{target} error=#{e.message} page_id=#{@page.id}"
    end
    if element.nil?
      if ignore_error_when_element_not_found
        return @page.log_error Result.new "Ignore error when element not found is true so return blank", value: ""
      else
        return @page.log_error Error.new "APIBOT_SEARCH: can not find #{target} in #{content} page_id=#{@page.id}".first(ActionDispatch::Cookies::MAX_COOKIE_SIZE / 4)
      end
    end

    value = if target_attribute.blank?
      element.text
    else
      return @page.log_error Error.new "APIBOT_ATTRIBUTE: #{target_attribute} not_found on #{element} page_id=#{@page.id}" unless element.key? target_attribute
      element[target_attribute]
    end
    regexp = regexp.strip
    if regexp.start_with?('["') || regexp.start_with?("['")
      # get inner [ ] and remove from regexp
      # TODO: convert the case when we start with [0] (we should still support
      # regexp like [^,] and [0][^,]
      index_of_closing_bracket = regexp.index("]")
      return @page.log_error Error.new "APIBOT_JSON: missing closing ] at regexp='#{regexp}' page_id=#{@page.id}" if index_of_closing_bracket.nil?

      keypath = regexp[0..index_of_closing_bracket]
      regexp = regexp[(index_of_closing_bracket + 1)..]
      begin
        data = JSON.parse(value)
      rescue JSON::ParserError => e
        return @page.log_error Error.new "APIBOT_JSON: error=#{e.message} at value='#{value}' page_id=#{@page.id}"
      end
      keypath = JSON.parse(keypath.gsub("'", '"'))
      value = if keypath == Inspect::KEYS_KEY
        data.keys
      else
        HashUtils.safe_dig data, keypath, "APIBOT_NOT_HASH_OR_ARRAY #{data} page_id=#{@page.id}"
      end
    end
    if regexp.start_with? '"'
      return @page.log_error Error.new "APIBOT_REGEXP missing closing quote at regexp='#{regexp}' page_id=#{@page.id}" unless regexp.end_with? '"'

      return Result.new "OK", value: regexp[1..-2]
    end
    if regexp.present?
      begin
        value = value.scan(Regexp.new regexp).join
      rescue RegexpError => e
        return @page.log_error Error.new "APIBOT_REGEXP: error=#{e.message} at regexp='#{regexp}' page_id=#{@page.id}"
      end
    end
    Result.new "OK", value: value
  end

  def interpolate(value, interpolation, hash)
    return value if interpolation.blank?

    hash = hash.dup # we do not want to add "this" to data
    hash["this"] = value
    regexp_string = Mustache::Parser::ALLOWED_CONTENT.source.gsub("*", "")
    sanitized_interpolation = interpolation.gsub(/\{\{\s*(.*?)\s*\}\}/) do
      inner_key = $1
      # we need to remove space and other not allowed chars
      clean = inner_key.scan(/#{regexp_string}/).join
      "{{#{clean}}}"
    end
    sanitized_hash = hash.transform_keys do |key|
      key.to_s.scan(/#{regexp_string}/).join
    end
    result = TemplateRenderService.new(sanitized_interpolation, sanitized_hash).render
    @page.log_error result unless result.success?
    result.message
  end
end
