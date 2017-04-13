require_relative 'init'

require 'rake/testtask'
require 'rake'

Rake::TestTask.new do |t|
  t.libs << '.'
  t.libs << 'test'
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
end

namespace :database do
  task :create do
    require 'dritorjan/database'
    Dritorjan::Database.create_database
  end

  task :create_tables do
    require 'dritorjan/database'
    Dritorjan::Database.connect
    Dritorjan::Database.create_tables
  end

  task :drop_tables do
    require 'dritorjan/database'
    Dritorjan::Database.connect
    Dritorjan::Database.drop_tables
  end

  task :reset do
    require 'dritorjan/database'
    Dritorjan::Database.connect
    Dritorjan::Database.drop_tables
    Dritorjan::Database.create_tables
  end
end
