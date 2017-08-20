require 'dritorjan'
require 'rollbar'

Rollbar.configure do |config|
  config.access_token = Settings.rollbar_token
  config.environment = Dritorjan.env
end
