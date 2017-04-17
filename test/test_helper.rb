ENV['RACK_ENV'] = 'test'
require_relative '../init'

require 'minitest/autorun'
require 'rr'
require 'faker'

require 'webmock/minitest'
WebMock.enable!

require 'sidekiq/testing'
Sidekiq::Testing.fake!

Dir.mkdir('./tmp') unless Dir.exist?('./tmp')
Dritorjan.logger = Logger.new('/dev/null')
