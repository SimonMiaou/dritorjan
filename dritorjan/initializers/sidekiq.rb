require 'sidekiq'
require 'airbrake/sidekiq'
require 'dritorjan/initializers/airbrake'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'dritorjan' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'dritorjan' }
end

Sidekiq.default_worker_options = { 'backtrace' => true }
