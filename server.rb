require 'sinatra'
require './cache_store'

configure { set :server, :puma }

include CacheStore

Dir["./services/*.rb"].each { |f| require f }

Cachy.cache_store = CacheStore.store

def host_name(request)
  "#{request.scheme}://#{request.host}:#{request.port}"
end

def path_helper(hostname, path)
  "#{hostname}/#{path}.json"
end

get '/' do
  FetcherService.new(:main).call
end

get '/start.json' do
  result = {
      playlist_name: 'Video.Melan',
      channels: [
          {
              title: 'Главная',
              playlist_url: path_helper(host_name(request), 'main'),
              description: 'Фильмы с главной'
          },
          {
              title: 'Новые',
              playlist_url: path_helper(host_name(request), 'new'),
              description: 'Недавно добавленные фильмы'
          },
          {
              title: "Поиск",
              search_on: "Поиск по каталогу",
              logo: '',
              playlist_url: path_helper(host_name(request), 'search'),
              description: "Поиск по всему каталогу Video.Melan"
          },
          {
              title: 'item',
              logo: '',
              stream_url: "#{host_name(request)}/kino.mp4",
              description: ""
          }
      ]
  }
  result.to_json
end

get '/main.json' do
  Cachy.cache(:main_films, expires_in: 1800) do
    {
        playlist_name: 'Главная',
        channels: FetcherService.new(:main, hostname: host_name(request)).call
    }.to_json
  end
end

get '/new.json' do
    {
        playlist_name: 'Недавно добавленные',
        channels: FetcherService.new(:new, hostname: host_name(request)).call
    }.to_json
end

get '/search.json' do
  {
      playlist_name: 'Результаты поиска',
      channels: RestGetter.new(params[:search], hostname: host_name(request)).call
  }.to_json
end

get '/get_url/:film_id' do
  Cachy.cache(params[:film_id]) do
    result = FetcherService.new(:get_film, params[:film_id].split('.').first, hostname: host_name(request)).call
    {
        playlist_name: result[1],
        channels: result[0]
    }.to_json
  end
end
