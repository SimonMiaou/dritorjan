require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'dritorjan.sqlite3')
require 'schema'

class Entry < ActiveRecord::Base
  def self.register(file_path)
    file = File.new(file_path)
    stat = file.lstat
    puts file.path

    entry = Entry.where(file_path: file_path).first
    entry ||= Entry.new(file_path: file_path)
    entry.dirname  = File.dirname(file_path)
    entry.basename = File.basename(file_path)
    entry.mtime    = stat.mtime
    entry.size     = stat.size
    entry.save!
  end
end
