require_relative 'init'

require 'dritorjan/initializers/sidekiq'
require 'sidekiq-scheduler'

# require the jobs
Dir.new('dritorjan/jobs').each do |file|
  next if ['.', '..'].include?(file)
  require "dritorjan/jobs/#{file}"
end
