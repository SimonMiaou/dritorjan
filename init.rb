ROOT_PATH = File.dirname(__FILE__)
$LOAD_PATH.unshift(ROOT_PATH)

require 'dritorjan'

require 'config'
Config.load_and_set_settings(Config.setting_files('./config', Dritorjan.env))
