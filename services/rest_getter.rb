require 'rest-client'

class RestGetter

  URL = 'http://video.melan/suggestion.php'.freeze

  def initialize(query)
    @query = query
  end

  def call
    parsed = JSON.parse(response)
    parsed['json'][0]['response']['movies'].map do |movie|
      {
          title: movie['name'],
          logo: '',
          playlist_url: path_helper("get_url/#{movie['movie_id']}"),
          description: "<img src='#{ParserService::BASE_URL}#{movie['cover']}'>"
      }
    end
  end

  private

  attr_reader :query

  def response
    @response ||= RestClient.get(URL, { params: { q: query } })
  end

end