require 'oj'
require 'watir'
require 'pstore'

class GetFilmService

  BASE_URL = "http://video.melan/#/movie/id/%{movie_id}"

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
    browser.goto BASE_URL % {movie_id: path}

    while browser.execute_script("return jQuery('.files').size()") == 0
      sleep 1
    end

    result = browser.div(class: 'files').table.trs.map do |item|
      {
          title: item.td(class: 'name').text,
          logo: '',
          stream_url: item.link.href,
          description: "#{item.td(class: 'name').text} - #{item.link.text.gsub('Скачать ', '')}".prepend("<div>#{browser.div(class: 'info').text}</div>")
      }
    end

    title = browser.title.split('/')[0..1].join(' - ')

    browser.quit
    headless.destroy

    [result, title]
  end
end