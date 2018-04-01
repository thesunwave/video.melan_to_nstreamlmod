require 'sinatra'
require './cache_store'

include CacheStore

Dir["./services/*.rb"].each { |f| require f }

Cachy.cache_store = CacheStore.store

def path_helper(path)
  "http://192.168.10.11:9393/#{path}.json"
end

get '/' do
  FetcherService.new(:main).call
end

get '/start.json' do
  result = {
      playlist_name: 'Video.Melan',
      channels: [
          {
              title: 'Новые',
              playlist_url: path_helper('new'),
              description: 'Недавно добавленные фильмы'
          },
          {
              title: "Поиск",
              search_on: "Поиск по каталогу",
              logo: '',
              playlist_url: path_helper('search'),
              description: "Поиск по всему каталогу Video.Melan"
          }
      ]
  }
  result.to_json
end

get '/new.json' do
  Cachy.cache(:new_films, expires_in: (30 * 60)) do
    {
        playlist_name: 'Новые',
        channels: FetcherService.new(:new).call
    }.to_json
  end
end

get '/search.json' do
  {
      playlist_name: 'Результаты поиска',
      channels: RestGetter.new(params[:search]).call
  }.to_json
end

get '/get_url/:film_id' do
  Cachy.cache(params[:film_id]) do
    result = FetcherService.new(:get_film, params[:film_id].split('.').first).call
    {
        playlist_name: result[1],
        channels: result[0]
    }.to_json
  end
end
