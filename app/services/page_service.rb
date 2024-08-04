# create page for each find_all
class PageService
  # ONE_TIME_ACTIONS are run before LOOPED_ACTIONS
  # we will create another for inside looped actions if needed
  ONE_TIME_ACTIONS = [
    FIND_AND_CLICK = :find_and_click,
    FILL_IN = :fill_in,
    ACTION_MOVE_TO_AND_CLICK = :action_move_to_and_click,
    ACTION_SLEEP = :action_sleep,
    ACTION_PAUSE = :action_pause,
  ].freeze
  LOOPED_ACTIONS = [
    VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR = :visit_page_find_link_and_visit_link_url_until_link_disappear,
    VISIT_PAGE_FIND_NEXT_BUTTON_AND_SUBMIT_UNTIL_BUTTON_IS_DISABLED = :visit_page_find_next_button_and_submit_until_button_is_disabled,
    FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM = :find_all_links_loop_through_all_to_visit_them,
    FIND_ALL_ELEMENTS_AND_CREATE_PAGES_FROM_THEM = :find_all_elements_and_create_pages_from_them,
    VISIT_LINKS_FROM_JSON_ARRAY = :visit_links_from_json_array,
    ITERATE_SCRIPT_UNTILL_SAME_RESPONSE_OCCURS = :iterate_script_untill_same_response_occurs,
  ].freeze
  ALL_ACTIONS = ONE_TIME_ACTIONS + LOOPED_ACTIONS
  ALL_SELECTOR_TYPES = Capybara::Selector.all.keys
  # => [:xpath, :css, :id, :field, :fieldset, :link, :button, :link_or_button, :fillable_field, :radio_button, :checkbox, :select, :datalist_input, :option, :datalist_option, :file_field, :label, :table, :table_row, :frame, :element]
  SELECTOR_TYPE_AND_FILTERS = ALL_SELECTOR_TYPES.each_with_object({}) do |selector_type, a|
    selector = Capybara::Selector.new selector_type, config: {}, format: nil
    # https://github.com/teamcapybara/capybara/blob/master/lib/capybara/queries/selector_query.rb#L262
    filters = \
      selector.expression_filters.keys +
        selector.node_filters.keys +
        Capybara::Queries::SelectorQuery::VALID_KEYS -
        Capybara::Queries::SelectorQuery::SPATIAL_KEYS
    a[selector_type] = filters.uniq
  end
  # Here are custom actions available selectors that needs to be defined for
  # each action
  AVAILABLE_SELECTOR_TYPES_FOR_ACTION = {
    FIND_AND_CLICK => ALL_SELECTOR_TYPES,
    FILL_IN => [:fillable_field],
    VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR => [:css, :xpath, :link],
    VISIT_PAGE_FIND_NEXT_BUTTON_AND_SUBMIT_UNTIL_BUTTON_IS_DISABLED => [:css, :xpath],
    FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM => [:css, :xpath, :link],
    FIND_ALL_ELEMENTS_AND_CREATE_PAGES_FROM_THEM => [:css, :xpath],
    VISIT_LINKS_FROM_JSON_ARRAY => [:data_store],
    ITERATE_SCRIPT_UNTILL_SAME_RESPONSE_OCCURS => [:code],
    ACTION_MOVE_TO_AND_CLICK => [:css],
    ACTION_SLEEP => [:duration],
    ACTION_PAUSE => [],
  }
  unless AVAILABLE_SELECTOR_TYPES_FOR_ACTION.keys.sort == ALL_ACTIONS.sort
    raise "please define all available selector type for #{ALL_ACTIONS - AVAILABLE_SELECTOR_TYPES_FOR_ACTION.keys}"
  end

  ACTIONS_THAT_DOES_NOT_NEED_LOCATOR = [ACTION_PAUSE]

  def initialize(run)
    @run = run
    @session = Capybara::Session.new @run.bot.headless? ? :selenium_chrome_headless : :selenium_chrome
  end

  def perform
    @run.in_progress!
    logger "START #{@run.bot.start_url}"
    process_one_time_actions_to_set_session_to_target_page @run.bot.start_url
    proccess_looped_actions_and_yield_url(@run.bot.start_url) do |url|
      logger "******** pages.create session.current_url=#{@session.current_url}"
      @run.pages.create! url: @session.current_url, content: @session.body
    end
    @run.finished_at = Time.zone.now
    if cancelled?
      @run.status = :cancelled
      logger 'CANCELLED'
    else
      @run.status = :finished
      logger 'FINISHED'
    end
    @run.save!
    Result.new 'OK'
  rescue \
    ArgumentError,
    Capybara::ElementNotFound, # also Capybara::ExpectationNotMet is incuded here
    Selenium::WebDriver::Error::WebDriverError, # when server breaks
    Net::HTTPNotFound, # when there is 404 page
    Addressable::URI::InvalidURIError, # when url contains space before http://
    # URI::InvalidURIError, # when url contains non ascee /komentar-dana/vise-od-nebrige-\u2013-treba-li-stranci-da-nam-biraju-vladu-i-pisu-ustav.html
    Nokogiri::CSS::SyntaxError => e # this is when search with css and invalid selector
    logger_error e.class.name + ' ' + e.message
    Error.new e.message
  rescue StandardError => e
    # you can use here for de-bug
    # let exception_notification notify us
    raise e
  ensure
    @session.quit
  end

  # this is called inside each LOOPED_ACTIONS so we can have nested loops,
  # eg when some first step is calling again, it passes completed_step_index is 0
  # which means that we ignore first step in next each_with_index.
  # also we ignore if we call first time completed_step_index == -1 for non
  # first step_index > 0 steps
  #
  # first_loop_action (only called once)
  #   second_loop_action (called for each first_loop_action)
  def proccess_looped_actions_and_yield_url(url, completed_step_index: -1)
    return if cancelled?
    @run.bot.steps.where(action: LOOPED_ACTIONS).each_with_index do |step, step_index|
      next if step_index <= completed_step_index # ignore since we already completed this step
      next if completed_step_index == -1 && step_index > 0
      case step.action.to_sym
      when VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR
        next_url = url
        # TODO move this limit to bot configuration
        limit_page_index = 0
        while !cancelled? && limit_page_index < 1000
          logger "@session.visit step_index=#{step_index} next_url = #{next_url}"
          @session.visit next_url
          proccess_looped_actions_and_yield_url(next_url, completed_step_index: step_index) do |url|
            logger "VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR yield #{url}"
            yield url
          end
          @session.visit next_url unless @session.current_url == next_url
          limit_page_index += 1
          # here we break looped action
          logger "@@@@@@@@@@ break has_selector?(#{step.selector_type.to_sym},#{step.locator}) is false" and break unless @session.has_selector?(step.selector_type.to_sym, step.locator)
          next_link = @session.first(step.selector_type.to_sym, step.locator)
          next_link_href = next_link['href'].to_s.split('#').first
          if next_link_href == @session.current_url
            logger "@@@@@@@@@ break since next_link_href points to the same url #{next_link_href}"
            # TODO add test for this same_url# link
            break
          end
          raise ArgumentError, "#{next_link.inspect} does not have href. Please check #{step.selector_type} locator='#{step.locator}' in #{step_index + 1} step" unless next_link_href.present?
          next_url = full_path(@session.current_url, next_link_href)
          logger "--------next_url = #{next_url}"
        end
        logger 'finished loop for VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR'
      when VISIT_PAGE_FIND_NEXT_BUTTON_AND_SUBMIT_UNTIL_BUTTON_IS_DISABLED
        # TODO move this limit to bot configuration
        limit_page_index = 0
        last_session_body = ""
        while !cancelled? && limit_page_index < 100
          logger "@session.submit step_index=#{step_index} limit_page_index = #{limit_page_index}"
          proccess_looped_actions_and_yield_url(url, completed_step_index: step_index) do |url|
            logger "VISIT_PAGE_FIND_NEXT_BUTTON_AND_SUBMIT_UNTIL_BUTTON_IS_DISABLED yield #{url}"
            yield url
          end
          next_button = @session.first(step.selector_type.to_sym, step.locator)
          break if next_button.disabled? || last_session_body == @session.body
          last_session_body = @session.body
          next_button.click
          limit_page_index += 1
        end
      when FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM
        @session.visit url
        on_page_links_hrefs = @session.all(step.selector_type.to_sym, step.locator).map { |link| link['href'] }
        on_page_links_hrefs.each do |href|
          one_link = full_path(@session.current_url, href)
          # logger "one_link href=#{one_link}"
          proccess_looped_actions_and_yield_url(one_link, completed_step_index: step_index) do |url|
            logger "FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM yield #{url}"
            @session.visit url
            yield url
          end
        end
      when FIND_ALL_ELEMENTS_AND_CREATE_PAGES_FROM_THEM
        elements = @session.all step.selector_type.to_sym, step.locator
        if elements.blank?
          logger "Can not find elements #{step.locator}"
        else
          elements.each do |element|
            @run.pages.create! url: @session.current_url, content: element.native['outerHTML']
          end
        end
      when VISIT_LINKS_FROM_JSON_ARRAY
        # todo last link one time actions are not triggered
        json_array.each do |json_array_item|
          result = TemplateRenderService.new(step.locator, json_array_item).render
          if result.success?
            yield result.message
          else
            logger_error result.message
          end
        end
      when ITERATE_SCRIPT_UNTILL_SAME_RESPONSE_OCCURS
        # TODO: use eval to run arbitrary ruby code. Available methods:
        # @session
        # proccess_looped_actions_and_yield_url
      else
        raise "unknown_step_action=#{step.action}"
      end
    end
    if @run.bot.steps.where(action: LOOPED_ACTIONS).size - 1 == completed_step_index
      # logger "END proccess_looped_actions_and_yield_url yield url=#{url} completed_step_index=#{completed_step_index}"
      yield url
    end
  end

  def process_one_time_actions_to_set_session_to_target_page(url)
    @session.visit url
    @run.bot.steps.where(action: ONE_TIME_ACTIONS).each do |step|
      case step.action.to_sym
      when FILL_IN
        @session.fill_in step.locator, with: step.filters['with']
      when FIND_AND_CLICK
        @session.first(step.selector_type.to_sym, step.locator).click
      when ACTION_MOVE_TO_AND_CLICK
        element = @session.first(step.selector_type.to_sym, step.locator)
        raise ArgumentError, "Can not find #{ste.locator}" if element.blank?
        @session.driver.browser.action.move_to(element.native,30,30).click_and_hold.release.perform
      when ACTION_SLEEP
        sleep step.locator.to_i
      when ACTION_PAUSE
        pause
      else
        raise "unknown_step_action=#{step.action}"
      end
    end
  end

  def pause
    $stderr.write 'Press ENTER to continue'
    $stdin.gets
  end

  def logger(msg)
    if @run.log.present?
      @run.log += "<br>#{msg}"
    else
      @run.log = msg
    end
    @run.save!
  end

  def logger_error(msg)
    if @run.error_log.present?
      @run.error_log += "<br>#{msg}"
    else
      @run.error_log = msg
    end
    @run.failed!
  end

  # link could be ?a=2, or /path or full url http://a.b/path
  def full_path(current_url, link)
    uri = URI current_url
    uri.merge link
  rescue URI::InvalidURIError => _e
    uri.merge URI.escape(link)
  end

  def cancelled?
    @cancelled ||= ApplicationJob.cancelled?(@run.job_id)
  end

  def json_array
    return @json_array if defined? @json_aarray
    uri = URI @run.bot.start_url
    response_body = Net::HTTP.get uri
    @json_array = JSON.parse response_body
  rescue \
    Net::HTTPNotFound => e # when there is 404 page
    logger_error "json_array #{@run.bot.start_url} e=#{e.message}"
    []
  end
end
