require 'sinatra'

class Webserver < Sinatra::Base
  get '/' do
    erb :index
  end
end
