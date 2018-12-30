require 'nokogiri'
require 'rest-client'

class FromRssService
  def initialize(hostname: nil)
    @url = "#{ParserService::BASE_URL}/rss_films.php"
    @hostname = hostname
  end

  def call
    response.xpath('//item').map do |item|
      {
          title: item.at_xpath('title').content,
          logo: '',
          playlist_url: path_helper(hostname, "get_url/#{film_id(item)}"),
          description: item.at_xpath('content:encoded').content
      }
    end
  end

  private

  attr_reader :url, :hostname

  def response
    @response ||= Nokogiri::XML(RestClient.get(url))
  end

  def film_id(item)
    item.at_xpath('link').content.split('/').last
  end
end
