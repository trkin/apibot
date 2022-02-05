# ApiBot a scheduled crawler

Opensource tool that you can host on your machine and use it for your scraping
needs.

# Start the app

Heroku, Docker

```
heroku buildpacks
heroku buildpacks:set heroku/ruby # https://github.com/heroku/heroku-buildpack-ruby
heroku buildpacks:add --index 1 heroku/nodejs # https://github.com/heroku/heroku-buildpack-nodejs
heroku buildpacks:add heroku/google-chrome # https://github.com/heroku/heroku-buildpack-google-chrome

# For https://stackoverflow.com/a/57671870/287166 Webdrivers::BrowserNotFound (Failed to find Chrome binary.):
heroku config:set WD_CHROME_PATH=/app/.apt/usr/bin/google-chrome
```

# Basic usage

When you start the app you can register first `User`. It will be a superadmin
which can manage other users on the platform. It is fine if there is only one
user, but in case you want have other projects that need scrapping, you can
create another `Company` and add other users to it.

Scrapping is performed in two steps, first is to download a html page using a
`Bot` and second is to parse downloaded data using `Inspect`.

`Bot` is defined with starting url. If the site does not require
javascript than you can choose `selenium_chrome` or `headless_selenium_chrome`.
If target data is not on the starting url than you can perform various `Step`s
to get to it: click on page elements, fill inputs and submit forms.

Main purpose of a bot when we `Run` it, is to get to the desired `Page` with
data we need (using `PageService`) and to perform inspection (using
`InspectService`).

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

Some examples you can run with a click on your api bot locally or on Heroku
http://trk-bot.herokuapp.com/examples

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
