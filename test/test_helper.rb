require_relative '../init'
ENV['DRITORJAN_ENV'] = 'test'

require 'minitest/autorun'
require 'rr'

require 'webmock/minitest'
WebMock.enable!

Config.load_and_set_settings(Config.setting_files('./config', 'test'))
Dir.mkdir('./tmp') unless Dir.exist?('./tmp')

require 'dritorjan'
Dritorjan.logger = Logger.new('./tmp/test.log')
