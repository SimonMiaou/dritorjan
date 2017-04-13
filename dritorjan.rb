require 'logger'

module Dritorjan
  def self.env
    ENV['RACK_ENV'] || 'development'
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
