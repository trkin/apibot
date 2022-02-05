# ApiBot a scheduled crawler

Opensource tool that you can host on your machine and use it for your scraping
needs.

# Start the app

Heroku, Docker

# Basic usage

When you start the app you can register first `User`. It will be a superadmin
which can manage other users on the platform. It is fine if there is only one
user, but in case you want have other projects that need scrapping, you can
create another `Company` and add other users to it.

Scrapping is performed in two steps, first is to download a html page using a
`Bot` and second is to parse downloaded data using `Inspect`.

`Bot` is defined with starting url and engine. If the site does not require
javascript than you can choose `mechanize` engine, otherwise you can choose
`selenium_chrome` or `headless_selenium_chrome`. If target data is not on the
starting url than you can perform various `Step`s to get to it: click on page
elements, fill inputs and submit forms.

Main purpose of a bot when we `Run` it, is to get to the desired `Page` with
data we need (using `PageService`) and to perform inspection (using
`InspectService`).

# Step Service

For example if you want to grab header text from url  than you do not need any
steps, initial `Page` will containt `...<h1>My Header</h1>...` so you just need
to inspect that html.

TODO: add examples

Another example is that you need to navigate using `find_and_click` and `fill_in`
steps, for example you need to log in.

Another example is that
in which case result is json object. Another
way is that steps uses some of the Looped actions that generate array
`<tr><td>Item1</td><td>1</td></tr>` and `<tr><td>Item2</td><td>2</td></tr>`. In
this case result is array of object that represents data on each page fragment.

Saved html is processed by `Inspect` to return data in clear formated format
(without html tags and spaces).
For that we are using Nokogiri
https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
For example for page `...<h1>My Header</h1>...` we can inspect `header: h1`, and
for table example we can inspect `name: td:nth-child(1)` and `count:
td:nth-child(2)`.
Generated data might look as an object with string values
```
{
  data: {
    header: 'My Header'
  }
}
```
or an array of objects with string values
```
{
  data: [
    {
      name: 'Item1',
      count: '1'
    },
    {
      name: 'Item2',
      count: '2'
    }
  ]
}
```

# Keywords

Web Scraping, Data Scraping, Data Mining, Data Extraction, Data Science,
Microsoft Excel, Extract, Transform and Load (ETL), Data Migration, Web Crawling

# Configuration

You can start the application on Heroku


To create your keys you can run `rails credentials:edit`

```
secret_key_base: 123
exception_recipients: my@gmail.com
mailer_sender: My Company <my@gmail.com>

smtp_username: my@gmail.com
smtp_password: mypassword

# captcha https://www.google.com/recaptcha/admin#site/_____?setup
google_recaptcha_site_key: 123
google_recaptcha_secret_key: 123
```

# Dependencies

It is using:
* Ruby on Rails v6.0.2
* ruby
* sidekiq
* postgresql

# Development

```
rails db:setup
```

Run tests

```
rake
```

# Similar tools

* Kimurai https://github.com/vifreefly/kimuraframework
