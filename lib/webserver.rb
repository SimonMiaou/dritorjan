require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/assetpack'
require 'slim'

require 'entry'

class Webserver < Sinatra::Base
  register Sinatra::AssetPack
  set :root, File.dirname(__FILE__)

  assets do
  end

  get '/' do
    slim :index
  end

  get '/entries' do
    response = {
      q:     params[:q],
      total: Entry.search(params[:q]).size,
      hits:  Entry.search(params[:q]).order(mtime: :desc)
    }
    json response
  end
end
