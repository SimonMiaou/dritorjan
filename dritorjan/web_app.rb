require 'dritorjan/helpers/abilities'
require 'dritorjan/helpers/authentication'
require 'dritorjan/helpers/format'
require 'dritorjan/helpers/view_helpers'
require 'dritorjan/initializers/airbrake'
require 'dritorjan/jobs/directory_scanner'
require 'dritorjan/models/entry'
require 'dritorjan/models/user'
require 'sinatra'
require 'slim'

require 'addressable'

module Dritorjan
  class WebApp < Sinatra::Base
    use Airbrake::Rack::Middleware
    use Rack::Session::Pool

    set :public_folder, 'dritorjan/public'

    helpers Helpers::Abilities
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

    get(%r{/scan(/(.*))}) do
      entry = Models::Entry.find Addressable::URI.unencode(params['captures'].first)

      redirect to(entry_url(entry))
    end

    post(%r{/scan(/(.*))}) do
      authenticate!

      entry = Models::Entry.find Addressable::URI.unencode(params['captures'].first)
      Jobs::DirectoryScanner.perform_async(entry.path) if can_scan?(entry)

      redirect to(entry_url(entry))
    end
  end
end
