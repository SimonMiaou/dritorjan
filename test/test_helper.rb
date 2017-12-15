ENV['RACK_ENV'] = 'test'
require_relative '../init'

require 'minitest/autorun'
require 'rr'
require 'faker'
require 'byebug'

require 'webmock/minitest'
WebMock.enable!

require 'sidekiq/testing'
Sidekiq::Testing.fake!

Dir.mkdir('./tmp') unless Dir.exist?('./tmp')
Dritorjan.logger = Logger.new('/dev/null')

require 'factory_bot'
module Minitest
  class Test
    include FactoryBot::Syntax::Methods
  end
end
