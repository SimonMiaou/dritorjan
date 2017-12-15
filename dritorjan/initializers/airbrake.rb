require 'airbrake'
require 'dritorjan'

unless Settings.airbrake.nil?
  Airbrake.configure do |c|
    c.project_id = Settings.airbrake.project_id
    c.project_key = Settings.airbrake.project_key

    c.environment = Dritorjan.env
    c.ignore_environments = Settings.airbrake.ignore_environments || %w[development test]
  end
end
