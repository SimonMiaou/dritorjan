require 'dritorjan/models/entry'
require 'sinatra'
require 'slim'

require 'addressable'

module Dritorjan
  class WebApp < Sinatra::Base
    get(/\A(.*)\z/) do
      @entry = Models::Entry.find params['captures'].first
      slim :index
    end
  end
end
