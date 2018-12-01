require 'oj'
require 'watir'
require 'pstore'

class GetFilmService

  BASE_URL = "http://video.melan/#/movie/id/%{movie_id}"

  def initialize(path = nil)
    # if RUBY_PLATFORM.match(/arm/)
      @browser = Watir::Browser.new :chrome, headless: true, options: { args: ['disable-gpu', 'no-sandbox', 'disable-dev-shm-usage'], binary: "/usr/bin/chromium" }
    # else
      # @browser = Watir::Browser.new :chrome, headless: true
    # end
    @path = path
  end

  def call
    parse
  end

  private

  attr_reader :browser, :path

  def parse
    browser.goto BASE_URL % {movie_id: path}

    while browser.execute_script("return jQuery('.files').size()") == 0
      sleep 1
    end

    result = browser.div(class: 'files').table.trs.map do |item|
      {
          title: item.td(class: 'name').text,
          logo: '',
          stream_url: "#{item.link.href.gsub('video.melan', '192.168.10.11:9393')}.kek",
          description: "#{item.td(class: 'name').text} - #{item.link.text.gsub('Скачать ', '')}".prepend("<div>#{browser.div(class: 'info').text}</div>")
      }
    end

    title = browser.title.split('/')[0..1].join(' - ')

    browser.quit
    [result, title]
  end
end
