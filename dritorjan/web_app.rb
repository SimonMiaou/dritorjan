require 'dritorjan/models/entry'
require 'sinatra'
require 'slim'

module Dritorjan
  class WebApp < Sinatra::Base
    get(/\A(.*)\z/) do
      @entry = Models::Entry.find_by path: params['captures'].first
      slim :index
    end
  end
end
