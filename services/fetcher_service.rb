require 'nokogiri'
require 'oj'
require 'rest-client'
require 'cachy'

class FetcherService

  BASE_URL = 'http://video.melan/'

  def initialize(kind, movie_id = nil, hostname: nil)
    @kind = kind
    @movie_url = movie_id
    @hostname = hostname
  end

  def call
    get_html
  end

  private

  def get_html
    case @kind
      when :main
        ParserService.new(hostname: @hostname).call
      when :get_film
        GetFilmService.new(@movie_url, hostname: @hostname).call
      when :new
        FromRssService.new(hostname: @hostname).call
      else
        {}
    end
  end
end
