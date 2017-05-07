require 'dritorjan/helpers/authentication'
require 'dritorjan/helpers/format'
require 'dritorjan/helpers/view_helpers'
require 'dritorjan/models/entry'
require 'dritorjan/models/user'
require 'sinatra'
require 'slim'

require 'addressable'

module Dritorjan
  class WebApp < Sinatra::Base
    use Rack::Session::Pool

    set :public_folder, 'dritorjan/public'

    helpers Helpers::Authentication
    helpers Helpers::Format
    helpers Helpers::ViewHelpers

    get '/' do
      redirect to('/entries/')
    end

    get '/login' do
      slim :login
    end

    post '/login' do
      user = Models::User.find_by login: params['login']

      if user.present? && user.password_match?(params['password'])
        session[:current_login] = user.login
        redirect to(session[:last_path] || '/')
      else
        redirect to('/login')
      end
    end

    get '/logout' do
      session[:current_login] = nil
      redirect to('/login')
    end

    get(%r{/entries(/(.*))}) do
      authenticate!

      @entry = Models::Entry.find Addressable::URI.unencode(params['captures'].first)
      slim :entry
    end
  end
end
