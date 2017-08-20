require 'dritorjan/initializers/rollbar'
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'dritorjan' }
end

Sidekiq.configure_server do |config|
  config.error_handlers << proc { |exception, _ctx_hash| Rollbar.error(exception) }
  config.redis = { namespace: 'dritorjan' }
end

Sidekiq.default_worker_options = { 'backtrace' => true }
