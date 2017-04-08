require_relative '../init'
ENV['DRITORJAN_ENV'] = 'test'

require 'minitest/autorun'
require 'rr'

require 'webmock/minitest'
WebMock.enable!
