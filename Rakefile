ROOT_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(ROOT_PATH + '/lib')

require 'rake'

task :scan do
  require 'fileutils'
  require 'dritorjan'

  now = Time.now

  config_path = ROOT_PATH + '/config.json'
  config = JSON.parse(File.read(config_path))
  config['directories'].each do |path|
    Dritorjan.scan_files(path)
  end

  Dritorjan.remove_before(now)
end
