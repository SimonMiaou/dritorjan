require_relative 'init'

require 'rake/testtask'
require 'rake'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
