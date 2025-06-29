require "test_helper"

class InspectServiceTest < ActiveSupport::TestCase
  setup do
    @service = InspectService.new fixture_page
  end

  test "#get_value APIBOT_NOKOGIRI" do
    content = "<div class='myclass'>hi</div>"
    target = ".myclass:non-existing"
    target_attribute = ""
    result = @service.get_value content, target, target_attribute
    assert_equal "APIBOT_NOKOGIRI: .myclass:non-existing error=xmlXPathCompOpEval: function non-existing not found", result.message
  end

  test "#get_value text text" do
    content = "<div class='myclass'>hi</div>"
    target = ".myclass"
    target_attribute = ""
    result = @service.get_value content, target, target_attribute
    assert_equal "hi", result.data[:value]
  end

  test "#get_value text json" do
    content = '<script type="application/ld+json">{"@context":"https://schema.org","@graph":[{"@type":"WebPage","@id":"https://mydomain.com"}]}</script>'
    target = "script"
    target_attribute = ""
    regexp = "['@graph'][0]['@id']"
    result = @service.get_value content, target, target_attribute, regexp
    assert_equal "https://mydomain.com", result.data[:value]

    regexp = '["@graph"][0]["@id"]'
    result = @service.get_value content, target, target_attribute, regexp
    assert_equal "https://mydomain.com", result.data[:value]
  end

  test "#get_value value" do
    content = "<input value='hi' class='myclass'>"
    target = ".myclass"
    target_attribute = "value"
    result = @service.get_value content, target, target_attribute
    assert_equal "hi", result.data[:value]
  end

  test "#get_value non_existing_attribute" do
    content = "<input value='hi' class='myclass'>"
    target = ".myclass"
    target_attribute = "non_existing_attribute"
    result = @service.get_value content, target, target_attribute
    assert_equal "APIBOT_ATTRIBUTE: non_existing_attribute not_found on <input value=\"hi\" class=\"myclass\">", result.message
  end

  test "#get_value static value" do
    content = "<input value='hi' class='myclass'>"
    target = "."
    target_attribute = ""
    regexp = '"static"'
    result = @service.get_value content, target, target_attribute, regexp
    assert_equal "static", result.data[:value]
  end
end
