# ApiBot

Opensource tool that you can use to fetch some data from internet. In the app
you can create `Bot` which will start the browser (if javascript is required you
can use headless chrome instead of mechanize), click on page elements, fill
inputs and submit forms so it can get to the desired page which is saved. Saved
page is processed by `Inspects` to return some data from the given html, for
example `h1` header text or array of `#my-list li` items.

# Example

The simplest way is to provide a link to a page and return text from the page.


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
