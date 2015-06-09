ROOT_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(ROOT_PATH + '/lib')

require 'webserver'

run Webserver
