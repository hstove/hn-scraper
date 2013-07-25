require "hn_scraper/version"
require 'nokogiri'
require 'rest-client'
require 'open-uri'

module HNScraper
  class << self
    def get_submit_fnid cookie
      headers = { "Cookie" => "user=#{cookie}" }
      doc = Nokogiri::HTML(RestClient.get("https://news.ycombinator.com/submit", headers))
      fnid = doc.css("input[name='fnid']")[0][:value]
    end

    def valid_hn_cookie? cookie
      doc = Nokogiri::HTML(open("https://news.ycombinator.com/news", "Cookie" => "user=#{cookie}"))
      return !doc.css('.pagetop')[1].text.match("login")
    end

    def get_login_cookie username, password
      doc = Nokogiri::HTML(RestClient.get("https://news.ycombinator.com/newslogin"))
      fnid = doc.css("input[name='fnid']")[0][:value]
      login_params = {u: username, p: password, fnid: fnid}
      cookie = nil
      RestClient.post('https://news.ycombinator.com/y', login_params){ |response, request, result, &block|
        cookie = response.cookies["user"]
        # if [301, 302, 307].include? response.code
        #   response.follow_redirection(request, result, &block)
        # else
        #   response.return!(request, result, &block)
        # end
      }
      cookie
    end

    def post_to_hn username, password, title, url, body=nil
      cookie = get_login_cookie(username, password)
      fnid = get_submit_fnid(cookie)
      params = {
        fnid: fnid,
        t: title
      }
      headers = {
        "Cookie" => "user=#{cookie}",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Content-Type" => "application/x-www-form-urlencoded",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31",
        "Origin" => "https://news.ycombinator.com",
        "Host" => "news.ycombinator.com"
      }
      if body.empty?
        params[:u] = url
      else
        params[:x] = body
      end
      res = RestClient.post("https://news.ycombinator.com/r", params, headers){ |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
    end

    def newest_link
      newest = Nokogiri::HTML(open("https://news.ycombinator.com/newest"))
      hn_link = newest.css('.subtext')[0].css('a:last-child')[0][:href]
    end
  end
end
