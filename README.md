# HnScraper

A gem for logging in and posting to Hacker News

## Installation

Add this line to your application's Gemfile:

    gem 'hn_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hn_scraper

## Usage

~~~Ruby
cookie = HNScraper.get_login_cookie("username", "password")
puts cookie
if HNScraper.valid_hn_cookie?(cookie)
  url = "https://github.com/hstove/hn-scraper"
  title = "A Ruby Gem for Posting to Hacker News"
  HNScraper.post_to_hn("username", "password", title, url)
  link = HNScraper.newest_link
  puts "Posted: #{link}"
end
~~~

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
