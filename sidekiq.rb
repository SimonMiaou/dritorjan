require_relative 'init'

require 'sidekiq-scheduler'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'dritorjan' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'dritorjan' }
end

# require the jobs
Dir.new('jobs').each do |file|
  next if file == '.' || file == '..'
  require "jobs/#{file}"
end
