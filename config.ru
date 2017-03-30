require_relative 'init'
$LOAD_PATH.unshift(ROOT_PATH + '/lib')

require 'webserver'

run Webserver
