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

  now = Time.now
  Dritorjan.scan_files('/home/simon/Desktop')
  # Dritorjan.remove_before(now)

  FileUtils.mv('dritorjan-tmp.sqlite3', 'dritorjan.sqlite3')
end
