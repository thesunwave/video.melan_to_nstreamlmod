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
          }
      ]
  }
  result.to_json
end

get '/new.json' do
  {
      playlist_name: 'Новые',
      channels: FetcherService.new(:new).call
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

'{"playlist_name":"IPTV",

"categories": [

{"category_id": "1",
"category_title": "общие"},

{"category_id": "2",
"category_title": "региональные"},

{"category_id": "3",
"category_title": "новостные"},

{"category_id": "4",
"category_title": "познавательные"},

{"category_id": "5",
"category_title": "развлекательные"}],

"channels": [

{	"title": "Поиск в листе по названию",
"logo": "logos/search.png",
"playlist_url": "SearchName",
"description": "Поиск в листе по названию"},

{	"title": "1+1",
"region": "187",
"logo": "http://avatars.yandex.net/get-tv-shows/1333715798818M75875/orig",
"category_id": "2",
"description": "620",
"stream_url": "http://ttv-kv-torrent1.ytv.su/1plus1.acelive"},

{	"title": "100 тв",
"logo": "",
"category_id": "3",
"description": "",
"stream_url": "acestream://df2045261d4930fe1776981dd3c8a8459ea58def"},

{	"title": "100% news",
"logo": "",
"category_id": "4",
"description": "",
"stream_url": "acestream://be9a805e86cc704be3ab8b3f7d7d6e6f40be0e21"},

{	"title": "112 украина",
"logo": "image.phg",
"category_id": "4",
"description": "",
"stream_url": "acestream://308084db066fe172cece7740576629a5cbe8912e"},

{	"title": "2+2",
"region": "187",
"logo": "http://avatars.yandex.net/get-tv-channel-logos/1372153849453M22479/orig",
"category_id": "2",
"description": "583",
"stream_url": "acestream://c8c9894c0f588b99e0117b6e2413ed35ce965222"},

{	"title": "2+2",
"region": "187",
"logo": "http://avatars.yandex.net/get-tv-channel-logos/1372153849453M22479/orig",
"category_id": "2",
"description": "583",
"stream_url": "http://ttv-kv-torrent1.ytv.su/2plus2.acelive"},

{	"title": "эко-тв",
"logo": "",
"category_id": "5",
"description": "<img src=\'logos/Radio 105 Network.png\' height=\'128\' width=\'128\'/>",
"stream_url": "acestream://e1702dbe34c30486afef50d9020ce526acbcfafb"}]}'