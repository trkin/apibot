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
      next unless inspect.enabled?

      result = get_value @page.content, inspect.target, inspect.target_attribute, inspect.regexp, inspect.ignore_error_when_element_not_found
      return result unless result.success?

      result_hash[inspect.name] = result.data[:value]
      inspect.transformations.each do |transformation|
        next if transformation.blank?
        result_hash[inspect.name] = case transformation
        when "titleize"
          result_hash[inspect.name].titleize
        when "upcase"
          result_hash[inspect.name].upcase
        when "downcase"
          result_hash[inspect.name].downcase
        when "to_lat"
          result_hash[inspect.name].to_lat
        when "to_cyr"
          result_hash[inspect.name].to_cyr
        when "slugify"
          Jekyll::Utils.slugify result_hash[inspect.name]
        else
          raise "unknown_transformation #{transformation}"
        end
      end
    end
    result_hash[:include_page_url_in_data] = @page.url if @page.run.bot.config[:include_page_url_in_data] == '1'
    result_hash[:include_apibot_url_in_data] = Rails.application.routes.url_helpers.page_url(@page) if @page.run.bot.config[:internal_show_page_url]
    @page.data = result_hash
    @page.error_log = nil
    @page.save! unless @disable_save
    Result.new 'OK', result_hash
  end

  def get_value(content, target, target_attribute, regexp = nil, ignore_error_when_element_not_found = false)
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
    if regexp.present?
      if regexp.start_with? '['
        begin
          data = JSON.parse(value)
        rescue JSON::ParserError => e
          return @page.log_error Error.new "APIBOT_JSON: error=#{e.message} at value='#{value}' page_id=#{@page.id}"
        end
        value = if regexp == Inspect::KEYS_KEY
          data.keys
        else
          dig_path data, regexp
        end
        regexp = regexp.gsub(/\[.*?\]/, "")
      end
      if regexp.start_with? '"'
        raise "missing_closing_quote" unless regexp.end_with? '"'

        return Result.new "OK", value: regexp[1..-2]
      end
      if regexp.present?
        begin
          value = value.scan(Regexp.new regexp).join
        rescue RegexpError => e
          return @page.log_error Error.new "APIBOT_REGEXP: error=#{e.message} at regexp='#{regexp}' page_id=#{@page.id}"
        end
      end
    end
    Result.new "OK", value: value
  end

  def dig_path(data, path_str)
    # Extract keys like ['@graph'][0]['@id'] into ["@graph", 0, "@id"]
    keys = path_str.scan(/\[(?:'([^']+)'|"([^"]+)"|(\d+))\]/).map do |s1, s2, index|
      index ? index.to_i : (s1 || s2)
    end

    # Traverse the hash/array using the extracted keys
    keys.inject(data) do |obj, key|
      obj.is_a?(Hash) || obj.is_a?(Array) ? obj[key] : "APIBOT_NOT_HASH_OR_ARRAY #{key} page_id=#{@page.id}"
    end
  end
end
