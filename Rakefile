$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')

require 'rake'

task :scan do
  require 'dritorjan'

  now = Time.now
  Dritorjan.scan_files('/home/simon/Desktop')
  Dritorjan.remove_before(now)
end
