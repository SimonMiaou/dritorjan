require 'sinatra/base'
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
end
