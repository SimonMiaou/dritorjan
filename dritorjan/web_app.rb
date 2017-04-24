require 'dritorjan/models/entry'
require 'sinatra'
require 'slim'

require 'addressable'

module Dritorjan
  class WebApp < Sinatra::Base
    helpers do
      def breadcrumb(entry)
        b = ''

        while entry.path != '/'
          link = "<a href=\"#{Addressable::URI.encode(entry.path)}\">#{entry.basename}</a>"
          b = "/#{link}#{b}"
          entry = entry.parent
        end

        b
      end

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
