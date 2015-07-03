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

task :auto_remove do
  Dritorjan.auto_remove
end

task :test_auto_remove, :where_clause do |t, args|
  puts 'Following entries should be removed:'
  Entry.where(args[:where_clause]).each do |entry|
    puts entry.file_path
  end
end
