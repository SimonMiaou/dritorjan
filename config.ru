require_relative 'init'

require 'dritorjan/initializers/sidekiq'
require 'sidekiq/web'

# https://github.com/mperham/sidekiq/wiki/Monitoring#standalone-with-basic-auth
map '/sidekiq' do
  use Rack::Auth::Basic, 'Protected Area' do |username, password|
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Settings.sidekiq.username)) &
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Settings.sidekiq.password))
  end

  run Sidekiq::Web
end
