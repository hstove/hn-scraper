require 'spec_helper'

describe HNScraper do
  before do
    @cookie = HNScraper.get_login_cookie("hnbuffer", "nwscom1225")
  end

  it "gets an FNID token for submitting" do
    fnid = HNScraper.get_submit_fnid(@cookie)
    fnid.should_not be(nil)
  end

  it "logs in successfully and validates correctly" do
    cookie = @cookie
    cookie.should_not be(nil)
    # cookie.should match("user=")
    doc = Nokogiri::HTML(open("https://news.ycombinator.com/news", "Cookie" => "user=#{cookie}"))
    doc.css('.pagetop')[1].text.should match("hnbuffer")
    
  end

  it "validates correct cookie successfully" do
    HNScraper.valid_hn_cookie?(@cookie).should eq(true)
  end

  it "raises error on unsuccessful login" do
    HNScraper.get_login_cookie("hnbuffer", "wrong").should be_nil
  end
end