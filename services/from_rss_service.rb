require 'nokogiri'
require 'rest-client'

class FromRssService
  def initialize
    @url = "#{ParserService::BASE_URL}/rss_films.php"
  end

  def call
    response.xpath('//item').map do |item|
      {
          title: item.at_xpath('title').content,
          logo: '',
          playlist_url: path_helper("get_url/#{film_id(item)}"),
          description: item.at_xpath('content:encoded').content
      }
    end
  end

  private

  attr_reader :url

  def response
    @response ||= Nokogiri::XML(RestClient.get(url))
  end

  def film_id(item)
    item.at_xpath('link').content.split('/').last
  end
end
