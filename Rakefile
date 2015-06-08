ROOT_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(ROOT_PATH + '/lib')

require 'rake'

task :scan do
  require 'fileutils'
  require 'dritorjan'

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ROOT_PATH + '/dritorjan-tmp.sqlite3')
  load 'schema.rb'

  config_path = ROOT_PATH + '/config.json'
  config = JSON.parse(File.read(config_path))
  config['directories'].each do |path|
    Dritorjan.scan_files(path)
  end

  FileUtils.mv(ROOT_PATH + '/dritorjan-tmp.sqlite3', ROOT_PATH + '/dritorjan.sqlite3')
end
