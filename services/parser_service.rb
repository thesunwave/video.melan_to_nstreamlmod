require 'oj'
require 'watir'
require 'pstore'
require 'headless'

class ParserService

  BASE_URL = 'http://video.melan/'

  def initialize(path = nil)
    @headless = Headless.new
    @browser = Watir::Browser.new :firefox
    @path = path
  end

  def call
    parse
  end

  private

  attr_reader :browser, :path, :headless

  def parse
    headless.start
    browser.goto BASE_URL

    while browser.execute_script("return jQuery('.item').size()") == 0
      sleep 1
    end

    result = browser.divs(class: 'item').map do |item|
      {
          title: item.text,
          logo: '',
          playlist_url: path_helper("get_url/#{item.link.href.split('/').last}"),
          description: "<img src='#{item.image.src}'>"
      }
    end

    browser.quit
    headless.destroy

    result
  end
end