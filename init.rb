ROOT_PATH = File.dirname(__FILE__)
$LOAD_PATH.unshift(ROOT_PATH)

require 'config'
Config.load_and_set_settings(Config.setting_files('./config', ENV['DRITORJAN_ENV'] || 'development'))
