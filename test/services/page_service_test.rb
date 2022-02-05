require 'application_system_test_case'

class StepServiceTest < ApplicationSystemTestCase
  # We need to start rack server, but we will not use it here since we are
  # testing the service (which will fetch those example pages)
  def setup
    visit root_path
  end
  def add_host(path)
    "http://127.0.0.1:#{Capybara.current_session.server.port}#{path}"
  end

  test 'no steps' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    assert_difference 'Page.count', 1 do
      result = PageService.new(run).perform
      assert result.success?
    end
    page = run.pages.last
    assert_equal add_host(paginated_with_links_path), page.url
    assert_match /book_1_title/, page.content
  end

  test 'FIND_AND_CLICK ONE_TIME_ACTIONS' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    step = bot.steps.create! action: PageService::FIND_AND_CLICK, selector_type: :link, locator: books(:book_1).title
    assert_difference 'Page.count', 1 do
      result = bot.create_and_perform_run
      assert result.success?, result.message
    end
    page = bot.last_page
    assert_equal add_host(paginated_with_links_book_path(books(:book_1))), page.url
  end

  test 'login follow redirect' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(sign_in_required_login_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    step = bot.steps.create! action: PageService::FILL_IN, selector_type: :fillable_field, locator: 'username'

  end

  test 'log show error for failed step because of Capybara::ElementNotFound' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    step = bot.steps.create! action: PageService::FIND_AND_CLICK, selector_type: :link_or_button, locator: 'unknown_element'
    assert_difference 'Page.count', 0 do
      result = PageService.new(run).perform
      refute result.success?
      assert_equal "expected to find link or button \"unknown_element\" at least 1 time but there were no matches", result.message
      run.reload
      assert_match "Capybara::ExpectationNotMet expected to find link or button \"unknown_element\" at least 1 time but there were no matches", run.error_log
    end
  end

  test 'log show error for failed step because of Nokogiri::CSS::SyntaxError' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    step = bot.steps.create! action: PageService::FIND_AND_CLICK, selector_type: :css, locator: 'bad=[format'
    assert_difference 'Page.count', 0 do
      result = PageService.new(run).perform
      refute result.success?
      run.reload
      assert_match 'Nokogiri::CSS::SyntaxError unexpected', run.error_log
    end
  end

  test 'log error for failed step because of bad url' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: '  http://a.com'
    run = bot.runs.create! status: Run::IN_PROGRESS
    assert_difference 'Page.count', 0 do
      result = PageService.new(run).perform
      refute result.success?
      run.reload
      assert_match 'InvalidURIError', run.error_log
    end
  end

  test 'it works with non asci chars in url on links' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(non_ascii_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    bot.steps.create! action: PageService::FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM, selector_type: :link, locator: 'шoу'
    expected_pages = 2
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'steps to interact without looped action FIND_AND_CLICK' do
    # TODO click on search fill in name submit
  end

  test 'pagination using Next VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    expected_pages = Const.examples[:number_of_books] / Const.examples[:per_page] + ((Const.examples[:number_of_books] % Const.examples[:per_page]).zero? ? 0 : 1)
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'pagination using Next VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR if there is only one page' do
    last_page = Const.examples[:number_of_books] / Const.examples[:per_page] + ((Const.examples[:number_of_books] % Const.examples[:per_page]).zero? ? 0 : 1)
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path(page: last_page))
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    expected_pages = 1
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM, selector_type: :css, locator: '.card-title a'
    expected_pages = Const.examples[:per_page]
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM and VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    bot.steps.create! action: PageService::FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM, selector_type: :css, locator: '.card-title a'
    expected_pages = Const.examples[:number_of_books]
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM and VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR if there is only one page' do
    last_page = Const.examples[:number_of_books] / Const.examples[:per_page] + ((Const.examples[:number_of_books] % Const.examples[:per_page]).zero? ? 0 : 1)
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path(page: last_page))
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    bot.steps.create! action: PageService::FIND_ALL_LINKS_LOOP_THROUGH_ALL_TO_VISIT_THEM, selector_type: :css, locator: '.card-title a'
    expected_pages = if (Const.examples[:number_of_books] % Const.examples[:per_page]).zero?
                       Const.examples[:number_of_books]
                     else
                       Const.examples[:number_of_books] % Const.examples[:per_page]
                     end
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'stop VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS, job_id: '123'
    bot.steps.create! action: PageService::VISIT_PAGE_FIND_LINK_AND_VISIT_LINK_URL_UNTIL_LINK_DISAPPEAR, selector_type: :css, locator: '[rel="next"]'
    ApplicationJob.cancel! '123'
    assert_difference 'Page.count', 0 do
      result = PageService.new(run).perform
      assert result.success?
      run.reload
      assert_match 'CANCELLED', run.log
    end
  end

  test 'FIND_ALL_ELEMENTS_AND_CREATE_PAGES_FROM_THEM' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(paginated_with_links_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::FIND_ALL_ELEMENTS_AND_CREATE_PAGES_FROM_THEM, selector_type: :css, locator: '.card-body'
    expected_pages = Const.examples[:per_page]
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
  end

  test 'VISIT_LINKS_FROM_JSON_ARRAY' do
    json_path = '/a.json'
    json_array = [{id: Book.first.id}]
    File.open("public/#{json_path}", 'w') do |f|
      f.write json_array.to_json
    end
    bot = companies(:my_company).bots.create! engine: Bot.engines[:mechanize], start_url: add_host(json_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::VISIT_LINKS_FROM_JSON_ARRAY, selector_type: :data_store, locator: add_host(paginated_with_links_path + '/{{id}}')
    expected_pages = 1
    assert_difference 'Page.count', expected_pages do
      result = PageService.new(run).perform
      assert result.success?
    end
    File.delete("public/#{json_path}") if File.exist?("public/#{json_path}")
  end

  test 'ACTION_MOVE_TO_AND_CLICK' do
    bot = companies(:my_company).bots.create! engine: Bot.engines[:selenium_chrome_headless], start_url: add_host(action_move_to_and_click_path)
    run = bot.runs.create! status: Run::IN_PROGRESS
    bot.steps.create! action: PageService::ACTION_MOVE_TO_AND_CLICK, selector_type: :css, locator: '#click-holder'
    bot.steps.create! action: PageService::ACTION_MOVE_TO_AND_CLICK, selector_type: :css, locator: 'iframe'
    assert_difference 'Page.count', 1 do
      result = PageService.new(run).perform
      assert result.success?
    end
    page = run.pages.last
    assert_match /Log: click body coordinates.*y=30/, page.content
  end
end
