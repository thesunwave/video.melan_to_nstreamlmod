require 'rest-client'

class RestGetter

  URL = 'http://video.melan/suggestion.php'.freeze

  def initialize(query, hostname: nil)
    @query = query
    @hostname = hostname
  end

  def call
    parsed = JSON.parse(response)
    result = parsed['json'][0]['response']['movies'].map do |movie|
      {
          title: movie['name'],
          logo: '',
          playlist_url: path_helper(hostname, "get_url/#{movie['movie_id']}"),
          description: "<img src='#{ParserService::BASE_URL}#{movie['cover']}'>"
      }
    end

    result.empty? ? fallback : result
  end

  private

  attr_reader :query, :hostname

  def response
    @response ||= RestClient.get(URL, { params: { q: query } })
  end

  def fallback
    [
        {
            title: 'Ничего не найдено',
            logo: '',
            playlist_url: '',
            description: ""
        }
    ]
  end

end
