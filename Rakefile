$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')

require 'rake'

task :scan do
  require 'fileutils'
  require 'dritorjan'

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'dritorjan-tmp.sqlite3')
  load 'schema.rb'

  config_path = File.dirname(__FILE__) + '/config.json'
  config = JSON.parse(File.read(config_path))
  config['directories'].each do |path|
    Dritorjan.scan_files(path)
  end

  FileUtils.mv('dritorjan-tmp.sqlite3', 'dritorjan.sqlite3')
end
