# Steps

Steps are used to navigate through the site so at the end, it can download and
save page for further inspecting using [Inspectors].

There are two kind of steps: Looped actions.

Step if defined using:
* `Action` one of the `L`
* `Locator` for example `h1`. In general it can be `element_name`,
  `.css_class_name`, `[attribute_name='attribute_value']`.
* regexp to filter text:
  * `\d+` to get only digits
  * `\S+(?: \S+)*` to get only one non space character between

Advance step configuration includes:
* `Enable log` to insert log messages

## find_click

Capybara#find https://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Finders#find-instance_method

More info [Capybara::Selector](https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Selector)
Locator can be `id`, `name`, `value`, `title`, `alt` attribute or string content
of the element.


## visit_link_until_it_disappear

It will click 

# Use cases

Extract
