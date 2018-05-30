require 'nokogiri'
require 'oj'
require 'rest-client'
require 'redis'
require 'cachy'

class FetcherService

  BASE_URL = 'http://video.melan/'

  def initialize(kind, movie_id = nil)
    @kind = kind
    @movie_url = movie_id
  end

  def call
    get_html
  end

  private

  def get_html
    case @kind
      when :main
        ParserService.new.call
      when :get_film
        GetFilmService.new(@movie_url).call
      when :new
        FromRssService.new.call
      else
        {}
    end
  end
end
