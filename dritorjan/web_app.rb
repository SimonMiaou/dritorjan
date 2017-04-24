require 'dritorjan/models/entry'
require 'sinatra'
require 'slim'

require 'addressable'

module Dritorjan
  class WebApp < Sinatra::Base
    helpers do
      def format_size(size)
        if size > 1_000_000_000
          size = (size.to_f / 1_000_000_000).round(2)
          "#{size} Go"
        elsif size > 1_000_000
          size = (size.to_f / 1_000_000).round(2)
          "#{size} Mo"
        elsif size > 1_000
          size = (size.to_f / 1_000).round(2)
          "#{size} Ko"
        else
          "#{size} o"
        end
      end
    end

    get(/\A(.*)\z/) do
      @entry = Models::Entry.find params['captures'].first
      slim :index
    end
  end
end
