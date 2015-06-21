ROOT_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(ROOT_PATH + '/lib')

require 'rake'
require 'dritorjan'

task :scan do
  now = Time.now
  Dritorjan.scan_files
  Dritorjan.remove_before(now)
end

task :free_space do
  Dritorjan.free_space
end
