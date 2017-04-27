require_relative 'init'

require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/user'
require 'dritorjan/web_app'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

# https://github.com/mperham/sidekiq/wiki/Monitoring#standalone-with-basic-auth
map '/sidekiq' do
  use Rack::Auth::Basic, 'Protected Area' do |login, password|
    user = Dritorjan::Models::User.find_by login: login
    user.present? && user.password_match?(password)
  end

  run Sidekiq::Web
end

run Dritorjan::WebApp
